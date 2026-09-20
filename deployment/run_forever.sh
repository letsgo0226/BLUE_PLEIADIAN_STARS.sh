#!/bin/sh
set -eu

mkdir -p "${DATA_DIR:-/data}"
t=1

while :
do
  if [ -f "${DATA_DIR:-/data}/state.json" ]; then
    t=$(python3 -c 'import json,sys;print(int(json.load(open(sys.argv[1])).get("tick",0))+1)' "${DATA_DIR:-/data}/state.json")
  fi

  if [ -n "${VERIFIER:-}" ]; then
    python3 /app/solver.py \
      --tick "$t" \
      --s "${S:-1}" \
      --N "${N:-16}" \
      --verifier "$VERIFIER" \
      --state "${DATA_DIR:-/data}/state.json" \
      --history "${DATA_DIR:-/data}/history.jsonl" \
      --graph "${DATA_DIR:-/data}/graph.json"
  else
    python3 /app/solver.py \
      --tick "$t" \
      --s "${S:-1}" \
      --N "${N:-16}" \
      --state "${DATA_DIR:-/data}/state.json" \
      --history "${DATA_DIR:-/data}/history.jsonl" \
      --graph "${DATA_DIR:-/data}/graph.json"
  fi

  sleep "${INTERVAL:-1}"
done
