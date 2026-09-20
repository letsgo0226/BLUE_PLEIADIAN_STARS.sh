#!/bin/sh
set -eu
BASE=$(CDPATH= cd "$(dirname "$0")" && pwd)
ROOT=${ROOT:-$(CDPATH= cd "$BASE/../.." && pwd)}
DATA_ROOT=${DATA_ROOT:-$ROOT/runtime_all_residents}
PIDFILE="$DATA_ROOT/supervisor.pid"
LOGFILE="$DATA_ROOT/supervisor.log"
mkdir -p "$DATA_ROOT"
case ${1:-status} in
 start)
  if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then echo "already running $(cat "$PIDFILE")"; exit 0; fi
  nohup env ROOT="$ROOT" DATA_ROOT="$DATA_ROOT" INTERVAL="${INTERVAL:-1}" STATE_VECTOR="${STATE_VECTOR:-0,0,0,0,0,0}" sh "$BASE/run_all.sh" >>"$LOGFILE" 2>&1 &
  echo $! >"$PIDFILE"; echo "started $(cat "$PIDFILE")";;
 stop)
  [ -f "$PIDFILE" ] || { echo "not running"; exit 0; }
  p=$(cat "$PIDFILE"); kill "$p" 2>/dev/null || true; rm -f "$PIDFILE"; echo "stopped";;
 restart) "$0" stop; "$0" start;;
 status)
  if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then echo "running $(cat "$PIDFILE")"; else echo "stopped"; exit 1; fi;;
 *) echo "usage: $0 {start|stop|restart|status}" >&2; exit 2;;
esac
