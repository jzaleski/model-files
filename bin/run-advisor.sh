#!/usr/bin/env bash

set -e;

llama-server \
  -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"gpt-oss-120b"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
  --alias ${ALIAS:-"jzaleski/advisor"} \
  --host ${HOST:-"0.0.0.0"} \
  --port ${PORT:-"8082"} \
  --ctx-size ${CTX_SIZE:-"131072"} \
  --fit ${FIT:-"on"} \
  --flash-attn ${FLASH_ATTN:-"on"} \
  --jinja \
  --min-p ${MIN_P:-"0"} \
  --n-gpu-layers ${N_GPU_LAYERS:-"99"} \
  --temp ${TEMP:-"1.0"} \
  --threads ${THREADS:-"32"} \
  --top-k ${TOP_K:-"0"} \
  --top-p ${TOP_P:-"1.0"};
