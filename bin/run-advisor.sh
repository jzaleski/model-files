#!/usr/bin/env bash

set -e;

run_local() {
  llama-server \
    -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"gpt-oss-20b"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
    --alias "${ALIAS:-"jzaleski/advisor"}" \
    --host "${HOST:-"127.0.0.1"}" \
    --port "${PORT:-"8082"}" \
    --ctx-size "${CTX_SIZE:-"131072"}" \
    --fit "${FIT:-"on"}" \
    --flash-attn "${FLASH_ATTN:-"on"}" \
    --jinja \
    --min-p "${MIN_P:-"0"}" \
    --n-gpu-layers "${N_GPU_LAYERS:-"99"}" \
    --threads "${THREADS:-"4"}" \
    --temp "${TEMP:-"1.0"}" \
    --top-k "${TOP_K:-"0"}" \
    --top-p "${TOP_P:-"1.0"}";
}

run_server() {
  llama-server \
    -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"gpt-oss-120b"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
    --alias "${ALIAS:-"jzaleski/advisor"}" \
    --host "${HOST:-"0.0.0.0"}" \
    --port "${PORT:-"8082"}" \
    --ctx-size "${CTX_SIZE:-"131072"}" \
    --fit "${FIT:-"on"}" \
    --flash-attn "${FLASH_ATTN:-"on"}" \
    --jinja \
    --min-p "${MIN_P:-"0"}" \
    --n-gpu-layers "${N_GPU_LAYERS:-"99"}" \
    --threads "${THREADS:-"32"}" \
    --temp "${TEMP:-"1.0"}" \
    --top-k "${TOP_K:-"0"}" \
    --top-p "${TOP_P:-"1.0"}";
}

# Default to local mode if no flag provided
if [[ "${1:-}" == "--server" ]]; then
  run_server
else
  run_local
fi
