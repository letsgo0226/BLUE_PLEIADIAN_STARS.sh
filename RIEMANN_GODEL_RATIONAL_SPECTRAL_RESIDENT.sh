#!/bin/sh
set -eu
ROOT=${ROOT:-$(CDPATH= cd "$(dirname "$0")" && pwd)}
DATA_DIR=${DATA_DIR:-$ROOT/runtime_riemann_godel_rational}
INTERVAL=${INTERVAL:-1}
STATE_VECTOR=${STATE_VECTOR:-0,0,0,0,0,0}
mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
while :
do
  sh "$ROOT/RIEMANN_GODEL_RATIONAL_SPECTRAL_HOLOGRAM_TM.sh" "$STATE_VECTOR"
  sleep "$INTERVAL"
done
