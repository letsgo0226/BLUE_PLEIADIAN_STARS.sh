#!/bin/sh
set -eu
ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
D=${STATE_DIR:-$HOME/.local/state/blue-pleiadian-stars/log-tm}
S=${LOG_TM_STATE:-$D/state.json};H=${HALT_FILE:-$D/HALT};L=${LOCK_DIR:-$D/daemon.lock}
mkdir -p "$D"
clean(){ rm -f "$L/pid";rmdir "$L" 2>/dev/null||:;};trap clean EXIT HUP INT TERM
if ! mkdir "$L" 2>/dev/null;then
 if [ -f "$L/pid" ]&&kill -0 "$(cat "$L/pid")" 2>/dev/null;then echo "UHEF_LOG_TM daemon active pid=$(cat "$L/pid")" >&2;exit 3;fi
 rm -rf "$L";mkdir "$L"
fi
echo "$$">"$L/pid"
echo "UHEF_LOG_TM resident: deadline-corrected 1 Hz state=$S halt=$H" >&2
NEXT=$(python3 -c 'import time;print(time.monotonic())')
while [ ! -e "$H" ];do
 LOG_TM_STATE="$S" MAX_TICKS=1 REV=0 sh "$ROOT/LOG_TM.sh"
 NEXT=$(python3 -c "print(float('$NEXT')+1)")
 python3 -c "import time;t=float('$NEXT')-time.monotonic();time.sleep(t if t>0 else 0)"
done
