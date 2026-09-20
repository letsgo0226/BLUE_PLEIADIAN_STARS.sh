#!/bin/sh
set -eu
ROOT=${ROOT:-$(CDPATH= cd "$(dirname "$0")/../.." && pwd)}
DATA_ROOT=${DATA_ROOT:-$ROOT/runtime_all_residents}
INTERVAL=${INTERVAL:-1}
STATE_VECTOR=${STATE_VECTOR:-0,0,0,0,0,0}
mkdir -p "$DATA_ROOT"
PIDS=""
start_script(){ name=$1; script=$2; shift 2; dir="$DATA_ROOT/$name"; mkdir -p "$dir"; (cd "$dir"; while :; do sh "$script" "$@" >>stdout.log 2>>stderr.log || true; sleep "$INTERVAL"; done) & PIDS="$PIDS $!"; }
start_solver(){ dir="$DATA_ROOT/exact_solver"; mkdir -p "$dir"; (cd "$dir"; while :; do if [ -n "${VERIFIER:-}" ]; then python3 "$ROOT/solver.py" --s "${S:-1}" --N "${N:-16}" --verifier "$VERIFIER" --state state.json --history history.jsonl --graph graph.json >>stdout.log 2>>stderr.log || true; else python3 "$ROOT/solver.py" --s "${S:-1}" --N "${N:-16}" --state state.json --history history.jsonl --graph graph.json >>stdout.log 2>>stderr.log || true; fi; sleep "$INTERVAL"; done) & PIDS="$PIDS $!"; }
cleanup(){ trap - INT TERM EXIT; for p in $PIDS; do kill "$p" 2>/dev/null || true; done; wait 2>/dev/null || true; }
trap cleanup INT TERM EXIT
start_solver
start_script exact_2kb "$ROOT/EXACT_PLEIADES_2KB_ONE_LINER.sh"
start_script v9_exact "$ROOT/v9_exact/UNIVERSAL_COSMIC_PRIME_HOLOGRAM_TM_v9_EXACT.sh"
start_script riemann_log_product "$ROOT/RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh"
start_script riemann_godel_rational "$ROOT/RIEMANN_GODEL_RATIONAL_SPECTRAL_HOLOGRAM_TM.sh" "$STATE_VECTOR"
start_script prime_index_hologram "$ROOT/PRIME_INDEX_HOLOGRAM_TM.sh"
wait
