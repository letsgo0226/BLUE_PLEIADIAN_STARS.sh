#!/bin/sh
set -eu

ROOT=$(CDPATH= cd "$(dirname "$0")/../.." && pwd)
STATE_DIR=${STATE_DIR:-$HOME/.local/state/blue-pleiadian-stars/dynamic-prime-vector}
STATE_FILE=${STATE_FILE:-$STATE_DIR/state.json}
HALT_FILE=${HALT_FILE:-$STATE_DIR/HALT}
NODE_DESCRIPTOR=${NODE_DESCRIPTOR:-$STATE_DIR/channel.json}
LOCK_DIR=${LOCK_DIR:-$STATE_DIR/daemon.lock}
HZ=${HZ:-1}

mkdir -p "$STATE_DIR"

cleanup_lock() {
  current=""
  if [ -f "$LOCK_DIR/pid" ]; then
    current=$(cat "$LOCK_DIR/pid" 2>/dev/null || true)
  fi
  if [ "$current" = "$$" ]; then
    rm -f "$LOCK_DIR/pid" 2>/dev/null || true
    rmdir "$LOCK_DIR" 2>/dev/null || true
  fi
}

acquire_lock() {
  if mkdir "$LOCK_DIR" 2>/dev/null; then
    printf '%s\n' "$$" > "$LOCK_DIR/pid"
    return 0
  fi

  oldpid=""
  [ ! -f "$LOCK_DIR/pid" ] || oldpid=$(cat "$LOCK_DIR/pid" 2>/dev/null || true)
  case "$oldpid" in
    ''|*[!0-9]*) ;;
    *)
      if kill -0 "$oldpid" 2>/dev/null; then
        echo "dynamic-prime-vector daemon already active pid=$oldpid" >&2
        exit 3
      fi
      ;;
  esac

  rm -f "$LOCK_DIR/pid" 2>/dev/null || true
  if rmdir "$LOCK_DIR" 2>/dev/null && mkdir "$LOCK_DIR" 2>/dev/null; then
    printf '%s\n' "$$" > "$LOCK_DIR/pid"
    echo "reclaimed stale dynamic-prime-vector lock" >&2
    return 0
  fi

  echo "dynamic-prime-vector lock could not be safely reclaimed; fail-closed" >&2
  exit 3
}

child=""
stop_child() {
  if [ -n "$child" ]; then
    kill "$child" 2>/dev/null || true
    wait "$child" 2>/dev/null || true
    child=""
  fi
}

on_exit() {
  stop_child
  cleanup_lock
}
trap on_exit EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

acquire_lock

if [ -e "$HALT_FILE" ]; then
  echo "HALT exists at $HALT_FILE; daemon remains stopped" >&2
  exit 0
fi

export STATE_FILE HALT_FILE NODE_DESCRIPTOR HZ
echo "DYNAMIC_PRIME_VECTOR_TM resident starting: hz=$HZ state=$STATE_FILE halt=$HALT_FILE" >&2

sh "$ROOT/DYNAMIC_PRIME_VECTOR_TM.sh" &
child=$!
wait "$child"
rc=$?
child=""
exit "$rc"
