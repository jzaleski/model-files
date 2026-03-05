# AI Tools

Utilities for running local LLMs with llama-server

## Overview

This repository provides scripts and configurations for running local AI models using llama-server. It includes support for multiple models with different use cases - coding assistance and general advising.

The system has been migrated from Ollama Modelfiles to llama-server binaries for better performance and flexibility.

## Prerequisites

- Docker (for Open WebUI)
- llama-server (for included scripts)
- At least 16GB RAM (for 20B advisor model and 9B coder model)
- GPU support recommended for better performance

## Environment Variables

You can override default settings via environment variables. The same variables apply to both local and server modes. Environment defaults differ between local and server modes as shown in the Components section.

**Common Variables:**
- `MODEL_PROVIDER`: Provider/organization name for the model (default: unsloth)
- `MODEL_NAME`: Name of the model to load (default varies by script and mode)
- `MODEL_QUANTIZATION`: Full quantization specification (default: Q8_0)
- `TEMP`: Controls randomness and creativity in model responses (lower values produce more deterministic outputs)
- `PORT`: Network port for the server to listen on for incoming connections
- `CTX_SIZE`: Maximum number of tokens the model can process in a single context window
- `N_GPU_LAYERS`: Number of model layers to offload to GPU for accelerated inference (default: 99)
- `THREADS`: Number of CPU threads allocated for parallel model processing (default: 4 for local, 32 for server)
- `MIN_P`: Threshold for nucleus sampling to exclude low-probability tokens
- `TOP_K`: Limit on the number of most likely tokens to consider during generation (0 or 0.0 disables top-k sampling)
- `REPEAT_PENALTY`: Factor applied to penalize repeated tokens to reduce repetition in output
- `ALIAS`: Custom name to register the model with llama-server
- `HOST`: Network interface address to bind the server to (127.0.0.1 for local, 0.0.0.0 for server)
- `FIT`: Enable model fit optimization (default: on)
- `FLASH_ATTN`: Boolean flag to enable flash attention mechanism for faster processing on supported hardware

## Components

### run-coder.sh
Runs a model for coding assistance. Supports both local and server modes via `--server` flag.

**Local Mode Defaults:**
- Model: `unsloth/Qwen3.5-9B-GGUF:Q8_0`
- Alias: `jzaleski/coder`
- Host: 127.0.0.1
- Port: 8081
- Context size: 262144 tokens
- Temperature: 1.0
- Min P: 0.01
- Repeat penalty: 1.0
- Threads: 4
- GPU layers: 99
- Flash attention: enabled

**Server Mode Defaults:**
- Model: `unsloth/Qwen3.5-122B-A10B-GGUF:Q8_0`
- Alias: `jzaleski/coder`
- Host: 0.0.0.0
- Port: 8081
- Context size: 262144 tokens
- Temperature: 1.0
- Min P: 0.01
- Repeat penalty: 1.0
- Threads: 32
- GPU layers: 99
- Flash attention: enabled

### run-advisor.sh
Runs a GPT-OSS model for general advising. Supports both local and server modes via `--server` flag.

**Local Mode Defaults:**
- Model: `unsloth/gpt-oss-20b-GGUF:Q8_0`
- Alias: `jzaleski/advisor`
- Host: 127.0.0.1
- Port: 8082
- Context size: 131072 tokens
- Temperature: 1.0
- Top K: 0 (disabled)
- Min P: 0 (disabled)
- Top P: 1.0
- Threads: 4
- GPU layers: 99
- Flash attention: enabled

**Server Mode Defaults:**
- Model: `unsloth/gpt-oss-120b-GGUF:Q8_0`
- Alias: `jzaleski/advisor`
- Host: 0.0.0.0
- Port: 8082
- Context size: 131072 tokens
- Temperature: 1.0
- Top K: 0 (disabled)
- Min P: 0 (disabled)
- Top P: 1.0
- Threads: 32
- GPU layers: 99
- Flash attention: enabled

### run-open-webui.sh
Starts Open WebUI interface using Docker.

**Default Configuration:**
- Port: 8080
- Uses advisor model on port 8082
- Custom advisor port via `ADVISOR_MODEL_PORT` env var

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

# Start Open WebUI
./bin/run-open-webui.sh
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

## Performance Tips

- GPU acceleration is enabled by default with 99 layers offloaded
- Use quantization level 4-5 for balance between speed and quality
- Adjust context size based on your use case
- Enable flash attention for better performance on supported hardware
- For coding tasks, use run-coder.sh with Qwen3.5-9B (local) or Qwen3.5-122B-A10B (server)
- For complex reasoning, use run-advisor.sh with GPT-OSS
- Adjust threads based on CPU cores for optimal performance
- Set `MIN_P` and `TOP_K` based on desired response quality

## Troubleshooting

**Model not loading:**
- Ensure you have enough RAM
- Check GPU availability if using GPU layers
- Verify model name and version
- Check that you're using the correct script (run-coder.sh or run-advisor.sh)

**Slow inference:**
- Enable GPU acceleration
- Reduce quantization level
- Decrease context size
- Enable flash attention
- Adjust `THREADS` based on CPU capacity

**WebUI connection issues:**
- Verify advisor model is running on configured port
- Check firewall settings
- Ensure Docker can reach host.docker.internal

**Quality issues:**
- Adjust `MIN_P` and `TOP_K` values based on desired response style (0 or 0.0 disables these sampling methods)
- For more creative responses, increase `TEMP` and `TOP_P` on advisor model

**Memory issues:**
- Reduce `CTX_SIZE` for smaller context windows
- Use lower quantization (Q4 instead of Q5)
- Set `N_GPU_LAYERS` to a specific value instead of 99
