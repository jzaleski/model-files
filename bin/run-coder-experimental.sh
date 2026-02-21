#!/usr/bin/env bash

set -e;

llama-server \
  -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"Qwen3-Coder-Next"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
  --alias ${ALIAS:-"jzaleski/coder-experimental"} \
  --host ${HOST:-"0.0.0.0"} \
  --port ${PORT:-"8081"} \
  --ctx-size ${CTX_SIZE:-"262144"} \
  --fit ${FIT:-"on"} \
  --flash-attn ${FLASH_ATTN:-"on"} \
  --jinja \
  --kv-unified \
  --min-p ${MIN_P:-"0.01"} \
  --n-gpu-layers ${N_GPU_LAYERS:-"99"} \
  --repeat-penalty ${REPEAT_PENALTY:-"1.0"} \
  --temp ${TEMP:-"1.0"} \
  --threads ${THREADS:-"32"} \
  --top-k ${TOP_K:-"40"} \
  --top-p ${TOP_P:-"0.95"};
