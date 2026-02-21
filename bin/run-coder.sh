#!/usr/bin/env bash

set -e;

llama-server \
  -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"GLM-4.7-Flash"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
  --alias ${ALIAS:-"jzaleski/coder"} \
  --host ${HOST:-"0.0.0.0"} \
  --port ${PORT:-"8081"} \
  --ctx-size ${CTX_SIZE:-"131072"} \
  --fit ${FIT:-"on"} \
  --flash-attn ${FLASH_ATTN:-"on"} \
  --jinja \
  --min-p ${MIN_P:-"0.01"} \
  --n-gpu-layers ${N_GPU_LAYERS:-"99"} \
  --repeat-penalty ${REPEAT_PENALTY:-"1.0"} \
  --temp ${TEMP:-"0.7"} \
  --threads ${THREADS:-"32"} \
  --top-p ${TOP_P:-"0.95"};
