#!/usr/bin/env bash

set -e;

MODEL_FAMILY=${MODEL_FAMILY:-"GLM"};
MODEL_FLAGS=();

if [ "$MODEL_FAMILY" = "GLM" ]; then
  MODEL="unsloth/GLM-${MODEL_VERSION:-"4.7-Flash"}-GGUF:Q${QUANT:-5}_K_${PARAMETERS:-"M"}";
  MODEL_FLAGS+=(
    "--ctx-size ${CTX_SIZE:-"65536"}"
    "--min-p ${MIN_P:-"0.01"}"
    "--n-gpu-layers ${N_GPU_LAYERS:-"99"}"
    "--repeat-penalty ${REPEAT_PENALTY:-"1.0"}"
    "--temp ${TEMP:-"0.7"}"
    "--top-p ${TOP_P:-"0.95"}"
  );
elif [ "$MODEL_FAMILY" = "QWEN" ]; then
  MODEL="unsloth/Qwen3-Coder-${MODEL_VERSION:-"480B-A35B-Instruct"}-GGUF:Q${QUANT:-"2"}_K_${PARAMETERS:-"XL"}"
  MODEL_FLAGS+=(
    "--ctx-size ${CTX_SIZE:-"65536"}"
    "--min-p ${MIN_P:-"0.0"}"
    "--n-gpu-layers ${N_GPU_LAYERS:-"99"}"
    "--override-tensor ${OVERRIDE_TENSOR:-".ffn_.*_exps.=CPU"}"
    "--repeat-penalty ${REPEAT_PENALTY:-"1.05"}"
    "--temp ${TEMP:-"0.7"}"
    "--top-k ${TOP_K:-"20"}"
    "--top-p ${TOP_P:-"0.8"}"
  );
else
  echo "Unmapped model-family: \"$MODEL_FAMILY\"" 1>&2;
  exit 1;
fi

llama-server \
  -hf ${MODEL} \
  --alias ${ALIAS:-"jzaleski/coder"} \
  --host ${HOST:-"0.0.0.0"} \
  --port ${PORT:-"8081"} \
  --jinja \
  --kv-unified \
  --mlock \
  --fit ${FIT:-"on"} \
  --flash-attn ${FLASH_ATTN:-"on"} \
  "${MODEL_FLAGS[@]}";
