#!/bin/bash
set -eo pipefail

source "evaluation/utils/version_control.sh"

DATASET=$1
MODEL_CONFIG=$2
EVAL_LIMIT=$3
# AGENT=$4
NWORKER=$4
LOGNAME=$5

if [ -z "$NUM_WORKERS" ]; then
  NUM_WORKERS=1
  echo "Number of workers not specified, use default $NUM_WORKERS"
fi
# ################################################################################

# if [ -z "$AGENT" ]; then
#   echo "Agent not specified, use default CodeActAgent"
#   AGENT="CodeActAgent"
AGENT="CodeActAgent"
# fi

if [ -z "$NWORKER" ]; then
  echo "NWORKER not specified, use default 1"
  NWORKER="1"
fi

if [ -z "$LOGNAME" ]; then
  echo "LOGNAME not specified, use default"
  LOGNAME="default"
fi

get_agent_version

echo "AGENT: $AGENT"
echo "AGENT_VERSION: $AGENT_VERSION"
echo "MODEL_CONFIG: $MODEL_CONFIG"

COMMAND="poetry run python evaluation/logic_reasoning/run_infer.py \
  --agent-cls $AGENT \
  --llm-config $MODEL_CONFIG \
  --dataset $DATASET \
  --max-iterations 10 \
  --max-chars 10000000 \
  --eval-num-workers $NWORKER \
  --log_name $LOGNAME \
  --eval-note $AGENT_VERSION"

if [ -n "$EVAL_LIMIT" ]; then
  echo "EVAL_LIMIT: $EVAL_LIMIT"
  COMMAND="$COMMAND --eval-n-limit $EVAL_LIMIT"
fi

# Run the command
eval $COMMAND
