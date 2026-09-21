#!/bin/sh
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
D=${STATE_DIR:-$HOME/.local/state/blue-pleiadian-stars/log-tm}
S=${LOG_TM_STATE:-$D/state.json};H=${HALT_FILE:-$D/HALT};L=${LOCK_DIR:-$D/daemon.lock};HZ=${HZ:-1}
mkdir -p "$D"
case "$HZ" in 1|1.0) ;; *) echo "LOG_TM daemon currently requires HZ=1" >&2;exit 2;; esac
clean(){ rmdir "$L" 2>/dev/null||:;};trap clean EXIT HUP INT TERM
mkdir "$L" 2>/dev/null||{ echo "LOG_TM daemon already active or stale lock exists: $L" >&2;exit 3;}
echo "$$">$L/pid
echo "AC_LOG_TM resident: 1 tick/second state=$S halt=$H" >&2
while [ ! -e "$H" ];do
 LOG_TM_STATE="$S" MAX_TICKS=1 REV=0 sh "$ROOT/LOG_TM.sh"
 sleep 1
done
