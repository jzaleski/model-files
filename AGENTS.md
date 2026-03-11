# AGENTS.md

Guidelines for agentic coding tools in this repository.

## Project Overview

Shell scripts and Docker configurations for running local LLMs using `llama-server`.
Supports coding assistance (GLM-4.7-Flash/Qwen3-Coder-Next) and general advising (gpt-oss-20b/Qwen3.5-122B-A10B).

**No code repositories** - utilities/config only.

---

## Build/Test Commands

Scripts in `bin/` support **local** and **server** modes:

```bash
./bin/run-coder.sh           # Local (default)
./bin/run-coder.sh --server  # Server mode
```

Test with: `bash -x ./bin/run-coder.sh`

---

## Code Style Guidelines

### Bash Scripts

- **Shebang**: `#!/usr/bin/env bash`
- **Error Handling**: `set -e;`
- **Variable Quoting**: `"${VAR:-default}"`
- **Functions**: Use `run_local()` and `run_server()`
- **Mode Detection**: `if [[ "${1:-}" == "--server" ]]; then run_server; else run_local; fi`
- **Environment Variables**: Always provide defaults via parameter expansion

### Configuration Files

- Docker Compose: Use `snake_case` naming
- Environment Variables: Use `${VAR:-default}` syntax

### Documentation

- Keep `README.md` updated
- Document all environment variables with defaults
- Include usage examples and ASCII diagrams

### Naming Conventions

- Scripts: `run-{component}.sh`
- Modes: `local` / `server`
- Ports: 8080 (WebUI), 8081 (coder), 8082 (advisor)
- Aliases: `jzaleski/{component}`

### Error Handling

1. Use `set -e`
2. Quote all variable expansions
3. Use `if [[ condition ]]; then` for conditionals

---

## Environment Variables

| Variable | Description | Default (Local) | Default (Server) |
|----------|-------------|-----------------|------------------|
| `MODEL_PROVIDER` | HuggingFace org | unsloth | unsloth |
| `MODEL_NAME` | Model name (no -GGUF) | GLM-4.7-Flash / gpt-oss-20b | Qwen3-Coder-Next / Qwen3.5-122B-A10B |
| `MODEL_QUANTIZATION` | Quantization level | Q4_K_M | Q5_K_M |
| `TEMP` | Sampling temperature | 1.0 | 1.0 |
| `PORT` | Network port | 8081/8082 | 8081/8082 |
| `CTX_SIZE` | Context window | 65536 | 65536 |

| `MIN_P` | Nucleus min | 0.01/0.0 | 0.01/0.0 |
| `TOP_K` | Top-K limit | 40/0.0 | 40/20 |

| `REPEAT_PENALTY` | Repeat penalty | 1.0 | 1.0 |
| `TOP_P` | Nucleus top-p | 0.95/1.0 | 0.95/0.95 |
| `ALIAS` | Model alias | jzaleski/{coder,advisor} | jzaleski/{coder,advisor} |
| `HOST` | Host address | 127.0.0.1 | 0.0.0.0 |

| `FLASH_ATTN` | Flash attention | on | on |

---

## Architecture

```
┌─────────────────┐
│   Open WebUI    │ (Port 8080)
│                 │
│  ┌───────────┐  │
│  │  Client   │  │
│  └─────┬─────┘  │
└────────┼────────┘
          │
          ▼
┌─────────────────┐
│  Advisor Model  │ (Port 8082)
│  gpt-oss-20b /  │
│  Qwen3.5-122B   │
└─────────────────┘
```

```
┌─────────────────┐
│   Coder Model   │ (Port 8081)
│  GLM-4.7-Flash  │
│  Qwen3-Coder-Next│
└─────────────────┘
```

---

## Performance

- GPU acceleration enabled with flash attention by default
- Use Q4-Q6 quantization for memory-constrained environments
- Context size standardized to 65536 tokens

## Docker Compose

```bash
docker compose -f docker-compose-files/open-webui.yml up
docker compose -f docker-compose-files/open-webui.yml down
```

## Troubleshooting

**Model not loading**: Verify RAM (16GB+), GPU/VRAM, model name and quantization.

**Connection failures**: Verify llama-server running, check `ADVISOR_MODEL_PORT`, ensure Docker host access.

**Performance issues**: Enable flash attention, reduce context size, adjust quantization.