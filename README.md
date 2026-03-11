# AI Tools

Utilities for running local LLMs with llama-server

## Overview

This repository provides scripts and configurations for running local AI models using llama-server. It includes support for multiple models with different use cases - coding assistance and general advising.

Models are loaded from HuggingFace and quantized for efficient local inference.

## Prerequisites

- Docker (for Open WebUI)
- llama-server (for included scripts)
- At least 16GB RAM for 20B+ models
- GPU support recommended

## Environment Variables

You can override default settings via environment variables. The same variables apply to both local and server modes. Environment defaults differ between local and server modes as shown in the Components section.

**Common Variables:**
- `MODEL_PROVIDER`: Provider/organization name for the model (default: unsloth)
- `MODEL_NAME`: Name of the model to load (default varies by script and mode)
- `MODEL_QUANTIZATION`: Full quantization specification (default: Q8_0)
- `TEMP`: Controls randomness and creativity in model responses
- `PORT`: Network port for the server to listen on for incoming connections
- `CTX_SIZE`: Maximum number of tokens the model can process in a single context window (65536-262144)

- `MIN_P`: Threshold for nucleus sampling to exclude low-probability tokens (0.0-1.0)
- `TOP_K`: Limit on the number of most likely tokens to consider during generation (0 or 0.0 disables top-k sampling)
- `REPEAT_PENALTY`: Factor applied to penalize repeated tokens (1.0 is no penalty)
- `TOP_P`: Controls nucleus sampling - cumulative probability threshold for token selection (0.95 default)
- `ALIAS`: Custom name to register the model with llama-server
- `HOST`: Network interface address to bind the server to (127.0.0.1 or 0.0.0.0)
- `FLASH_ATTN`: Boolean flag to enable flash attention mechanism for faster processing on supported hardware
- `N_GPU_LAYERS`: Number of layers to offload to GPU (-1 for all layers, default: -1)

## Components

### run-coder.sh
Runs the default model for coding assistance. Supports both local and server modes via `--server` flag.

**Local Mode Defaults:**
- Model: `unsloth/GLM-4.7-Flash-GGUF:Q4_K_M`
- Alias: `jzaleski/coder`
- Host: 127.0.0.1
- Port: 8081
- Context size: 65536 tokens
- Temperature: 1.0
- Min P: 0.01
- Top K: 40
- Repeat penalty: 1.0
- Top P: 0.95
- GPU layers: -1 (All)
- Flash attention: enabled

**Server Mode Defaults:**
- Model: `unsloth/Qwen3-Coder-Next-GGUF:Q5_K_M`
- Alias: `jzaleski/coder`
- Host: 0.0.0.0
- Port: 8081
- Context size: 65536 tokens
- Temperature: 1.0
- Min P: 0.01
- Top K: 40
- Repeat penalty: 1.0
- Top P: 0.95
- GPU layers: -1 (All)
- Flash attention: enabled

### run-advisor.sh
Runs the default model for general advising. Supports both local and server modes via `--server` flag.

**Local Mode Defaults:**
- Model: `unsloth/gpt-oss-20b-GGUF:Q4_K_M`
- Alias: `jzaleski/advisor`
- Host: 127.0.0.1
- Port: 8082
- Context size: 65536 tokens
- Temperature: 1.0
- Top K: 0.0 (disabled)
- Min P: 0.0
- Top P: 1.0
- GPU layers: -1 (All)
- Flash attention: enabled

**Server Mode Defaults:**
- Model: `unsloth/Qwen3.5-122B-A10B-GGUF:Q5_K_M`
- Alias: `jzaleski/advisor`
- Host: 0.0.0.0
- Port: 8082
- Context size: 65536 tokens
- Temperature: 1.0
- Top K: 20
- Min P: 0.0
- Top P: 0.95
- GPU layers: -1 (All)
- Flash attention: enabled



### run-open-webui.sh
Starts Open WebUI interface using Docker. Supports both local and server modes via `--server` flag.

**Local Mode Defaults:**
- Port: 8080
- WEBUI Auth: disabled
- Uses advisor model on port 8082

**Server Mode Defaults:**
- Port: 8080
- WEBUI Auth: enabled
- Uses advisor model on port 8082

**Environment Variables:**
- `WEBUI_AUTH`: Enable authentication in WebUI (default: False)
- `ADVISOR_MODEL_PORT`: Custom advisor model port (default: 8082)

## Usage

### Running Individual Models

```bash
# Run coding model (local mode)
./bin/run-coder.sh

# Run coding model (server mode)
./bin/run-coder.sh --server

# Run advisor model (local mode)
./bin/run-advisor.sh

# Run advisor model (server mode)
./bin/run-advisor.sh --server

# Start Open WebUI (local mode, auth disabled)
./bin/run-open-webui.sh

# Start Open WebUI (server mode, auth enabled)
./bin/run-open-webui.sh --server
```

## Docker Compose

Open WebUI can also be managed via Docker Compose:

```bash
docker compose -f docker-compose-files/open-webui.yml up
```

Stop with:
```bash
docker compose -f docker-compose-files/open-webui.yml down
```

## Architecture

```
┌──────────────────┐
│    Open WebUI    │ (Port 8080)
│                  │
│   ┌──────────┐   │
│   │  Client  │   │
│   └─────┬────┘   │
└─────────┼────────┘
          │
          ▼
┌──────────────────┐
│   Advisor Model  │ (Port 8082)
│   gpt-oss-20b /  │
│   Qwen3.5-122B   │
└──────────────────┘
```

```
┌──────────────────┐
│   Coder Model    │ (Port 8081)
│  GLM-4.7-Flash   │
│ Qwen3-Coder-Next │
└──────────────────┘
```

## Performance Tips

- GPU acceleration enabled with flash attention by default
- Use Q4-Q6 quantization for memory-constrained environments
- Context size standardized to 65536 tokens
- For coding tasks, use run-coder.sh with GLM-4.7-Flash (local) or Qwen3-Coder-Next (server)
- For complex reasoning, use run-advisor.sh with gpt-oss-20b (local) or Qwen3.5-122B-A10B (server)

## Troubleshooting

**Model not loading:**
- Ensure you have enough RAM
- Verify model name and quantization

**Slow inference:**
- Enable flash attention
- Reduce context size
- Adjust quantization level

**WebUI connection issues:**
- Verify advisor model is running on configured port
- Check firewall settings
- Ensure Docker can reach host.docker.internal

**Quality issues:**
- Adjust `MIN_P` and `TOP_K` values based on desired response style (0 or 0.0 disables these sampling methods)
- For more creative responses, increase `TEMP` and `TOP_P` on advisor model

**Memory issues:**
- Reduce `CTX_SIZE` for smaller context windows
- Use lower quantization (Q4/5 instead of Q8)
