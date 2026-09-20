#!/bin/sh
set -eu
BASE=$(CDPATH= cd "$(dirname "$0")" && pwd)
DATA_DIR=${DATA_DIR:-$BASE/runtime_prime_index}
INTERVAL=${INTERVAL:-1}
mkdir -p "$DATA_DIR"
cd "$DATA_DIR"
while :
do
  sh "$BASE/PRIME_INDEX_HOLOGRAM_TM.sh"
  sleep "$INTERVAL"
done
