# AGENTS.md

Guidelines for agentic coding tools in this repository.

## Project Overview

Shell scripts and Docker configurations for running local LLMs using `llama-server`.
Supports coding assistance and general advising models.

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
| `MODEL_NAME` | Model name (no -GGUF) | Qwen3.5-9B | Qwen3.5-122B-A10B |
| `MODEL_QUANTIZATION` | Quantization level | Q8_0 | Q8_0 |
| `TEMP` | Sampling temperature | 1.0 | 1.0 |
| `PORT` | Network port | 8081/8082 | 8081/8082 |
| `CTX_SIZE` | Context window | 262144/131072 | 262144/131072 |
| `N_GPU_LAYERS` | GPU layer count | 99 | 99 |
| `THREADS` | CPU threads | 4 | 32 |
| `MIN_P` | Nucleus min | 0.0 | 0.0 |
| `TOP_K` | Top-K limit | 20 | 20 |
| `PRESENCE_PENALTY` | Presence penalty | 0.0/1.5 | 0.0/1.5 |
| `REPEAT_PENALTY` | Repeat penalty | 1.0 | 1.0 |
| `ALIAS` | Model alias | jzaleski/{coder,advisor} | jzaleski/{coder,advisor} |
| `HOST` | Host address | 127.0.0.1 | 0.0.0.0 |
| `FIT` | Fit optimization | on | on |
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
│  GPT-OSS 120B   │
└─────────────────┘
```

```
┌─────────────────┐
│   Coder Model   │ (Port 8081)
│     Qwen3.5     │
│  9B / 122B-A10B │
└─────────────────┘
```

---

## Performance

- GPU acceleration enabled by default (99 layers offloaded)
- Use Q4-Q6 quantization for memory-constrained environments
- Adjust `THREADS` based on CPU cores
- Enable flash attention for supported hardware

## Docker Compose

```bash
docker compose -f docker-compose-files/open-webui.yml up
docker compose -f docker-compose-files/open-webui.yml down
```

## Troubleshooting

**Model not loading**: Verify RAM (16GB+), GPU/VRAM, model name and quantization.

**Connection failures**: Verify llama-server running, check `ADVISOR_MODEL_PORT`, ensure Docker host access.

**Performance issues**: Enable flash attention, reduce context size, adjust quantization.