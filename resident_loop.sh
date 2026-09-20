#!/bin/sh
set -eu
while :
do
  if [ -n "${VERIFIER:-}" ]; then
    python3 solver.py --s "${S:-1}" --N "${N:-16}" --verifier "$VERIFIER"
  else
    python3 solver.py --s "${S:-1}" --N "${N:-16}"
  fi
  sleep 1
done
