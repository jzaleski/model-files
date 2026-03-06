#!/usr/bin/env bash

set -e;

run_local() {
  llama-server \
    -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"Qwen3.5-9B"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
    --alias "${ALIAS:-"jzaleski/advisor-experimental"}" \
    --host "${HOST:-"127.0.0.1"}" \
    --port "${PORT:-"8082"}" \
    --ctx-size "${CTX_SIZE:-"131072"}" \
    --fit "${FIT:-"on"}" \
    --flash-attn "${FLASH_ATTN:-"on"}" \
    --jinja \
    --n-gpu-layers "${N_GPU_LAYERS:-"99"}" \
    --threads "${THREADS:-"4"}" \
    --min-p "${MIN_P:-"0.0"}" \
    --presence-penalty "${PRESENCE_PENALTY:-"1.5"}" \
    --repeat-penalty ${REPEAT_PENALTY:-"1.0"} \
    --temp "${TEMP:-"1.0"}" \
    --top-k "${TOP_K:-"20"}" \
    --top-p "${TOP_P:-"0.95"}";
}

run_server() {
  llama-server \
    -hf "${MODEL_PROVIDER:-"unsloth"}/${MODEL_NAME:-"Qwen3.5-122B-A10B"}-GGUF:${MODEL_QUANTIZATION:-"Q8_0"}" \
    --alias "${ALIAS:-"jzaleski/advisor-experimental"}" \
    --host "${HOST:-"0.0.0.0"}" \
    --port "${PORT:-"8082"}" \
    --ctx-size "${CTX_SIZE:-"131072"}" \
    --fit "${FIT:-"on"}" \
    --flash-attn "${FLASH_ATTN:-"on"}" \
    --jinja \
    --n-gpu-layers "${N_GPU_LAYERS:-"99"}" \
    --threads "${THREADS:-"32"}" \
    --min-p "${MIN_P:-"0.0"}" \
    --presence-penalty "${PRESENCE_PENALTY:-"1.5"}" \
    --repeat-penalty ${REPEAT_PENALTY:-"1.0"} \
    --temp "${TEMP:-"1.0"}" \
    --top-k "${TOP_K:-"20"}" \
    --top-p "${TOP_P:-"0.95"}";
}

# Default to local mode if no flag provided
if [[ "${1:-}" == "--server" ]]; then
  run_server
else
  run_local
fi
