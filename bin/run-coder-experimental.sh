#!/usr/bin/env bash

set -e;

llama-server \
  -hf "unsloth/${MODEL_VERSION:-"Qwen3.5-397B-A17B"}-GGUF:Q${QUANT:-5}_K_${PARAMETERS:-"M"}" \
  --alias ${ALIAS:-"jzaleski/coder-experimental"} \
  --host ${HOST:-"0.0.0.0"} \
  --port ${PORT:-"8081"} \
  --ctx-size ${CTX_SIZE:-"32768"} \
  --fit ${FIT:-"on"} \
  --flash-attn ${FLASH_ATTN:-"on"} \
  --jinja \
  --kv-unified \
  --min-p ${MIN_P:-"0.0"} \
  --mlock \
  --n-gpu-layers ${N_GPU_LAYERS:-"-1"} \
  --repeat-penalty ${REPEAT_PENALTY:-"1.0"} \
  --temp ${TEMP:-"0.6"} \
  --threads ${THREADS:-"32"} \
  --top-k ${TOP_K:-"20"} \
  --top-p ${TOP_P:-"0.95"};
