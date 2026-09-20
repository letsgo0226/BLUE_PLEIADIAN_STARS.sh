#!/bin/sh
set -eu
ROOT=${ROOT:-/app}
DATA_DIR=${DATA_DIR:-/data}
INTERVAL=${INTERVAL:-1}
mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
while :
do
  sh "$ROOT/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh"
  sleep "$INTERVAL"
done
