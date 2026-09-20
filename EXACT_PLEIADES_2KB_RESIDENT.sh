#!/bin/sh
set -eu
ROOT=${ROOT:-$(CDPATH= cd "$(dirname "$0")" && pwd)}
DATA_DIR=${DATA_DIR:-$ROOT/runtime_exact_2kb}
INTERVAL=${INTERVAL:-1}
mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
while :
do
  sh "$ROOT/EXACT_PLEIADES_2KB_ONE_LINER.sh"
  sleep "$INTERVAL"
done
