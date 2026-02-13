#!/usr/bin/env bash

set -e;

MODEL=${MODEL:-"unsloth/gpt-oss-${MODEL_VERSION:-"20b"}-GGUF:Q${QUANT:-5}_K_${PARAMETERS:-"M"}"};
ALIAS=${ALIAS:-"jzaleski/advisor"};

HOST=${HOST:-"0.0.0.0"};
PORT=${PORT:-"8082"};

CTX_SIZE=${CTX_SIZE:-"16384"};
FIT=${FIT:-"on"};
FLASH_ATTN=${FLASH_ATTN:-"on"};
N_GPU_LAYERS=${N_GPU_LAYERS:-"-1"};
TEMP=${TEMP:-"1.0"};
TOP_K=${TOP_K:-"0"};
TOP_P=${TOP_P:-"1.0"};

llama-server \
  -hf ${MODEL} \
  --alias ${ALIAS} \
  --host ${HOST} \
  --port ${PORT} \
  --jinja \
  --kv-unified \
  --mlock \
  --ctx-size ${CTX_SIZE} \
  --fit ${FIT} \
  --flash-attn ${FLASH_ATTN} \
  --n-gpu-layers ${N_GPU_LAYERS} \
  --temp ${TEMP} \
  --top-k ${TOP_K} \
  --top-p ${TOP_P};
