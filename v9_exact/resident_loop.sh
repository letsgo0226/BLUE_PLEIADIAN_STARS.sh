#!/bin/sh
set -eu
ROOT=${ROOT:-$(CDPATH= cd "$(dirname "$0")/.." && pwd)}
DATA_DIR=${DATA_DIR:-$ROOT/runtime_v9_exact}
INTERVAL=${INTERVAL:-1}
mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
while :
do
  sh "$ROOT/v9_exact/UNIVERSAL_COSMIC_PRIME_HOLOGRAM_TM_v9_EXACT.sh"
  sleep "$INTERVAL"
done
