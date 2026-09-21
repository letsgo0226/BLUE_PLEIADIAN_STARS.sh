#!/bin/sh
set -eu

command -v python3 >/dev/null 2>&1 || {
  echo "python3 is required" >&2
  exit 127
}

exec python3 - "$@" <<'PY'
from __future__ import annotations

from decimal import Decimal, InvalidOperation
from pathlib import Path
import json
import os
import tempfile
import time

MODEL = "DYNAMIC_PRIME_VECTOR_TM"
SCHEMA = 1

state_path = Path(os.environ.get("STATE_FILE", "state.json")).expanduser()
halt_path = Path(os.environ.get("HALT_FILE", "HALT")).expanduser()
descriptor_path = Path(
    os.environ.get(
        "NODE_DESCRIPTOR",
        "~/.config/blue-pleiadian-stars/dynamic-prime-vector-channel.json",
    )
).expanduser()
node_address = os.environ.get(
    "UVTM_NODE_ADDRESS",
    "uvtm://public-blue-pleiadian-stars/dynamic-prime-vector",
)
max_ticks = int(os.environ.get("MAX_TICKS", "0"))

try:
    hz_dec = Decimal(os.environ.get("HZ", "1"))
except InvalidOperation as exc:
    raise SystemExit("HZ must be a positive number") from exc
if hz_dec <= 0:
    raise SystemExit("HZ must be > 0")
hz = float(hz_dec)
interval = 1.0 / hz


def atomic_json(path: Path, payload: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp = tempfile.mkstemp(prefix=path.name + ".", dir=str(path.parent))
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as f:
            json.dump(payload, f, sort_keys=True, separators=(",", ":"), ensure_ascii=False)
            f.write("\n")
            f.flush()
            os.fsync(f.fileno())
        os.replace(tmp, path)
    finally:
        if os.path.exists(tmp):
            os.unlink(tmp)


def normalize(raw: dict | None) -> dict:
    raw = raw or {}
    out = {
        "schema": SCHEMA,
        "model": MODEL,
        "t": int(raw.get("t", 0)),
        "pc": int(raw.get("pc", 0)),
        "n": int(raw.get("n", 0)),
        "p": int(raw.get("p", 1)),
        "c": int(raw.get("c", 2)),
        "d": int(raw.get("d", 2)),
        "credential_value_present": False,
    }
    if min(out["t"], out["n"]) < 0:
        raise ValueError("t and n must be non-negative")
    if out["p"] < 1 or out["c"] < 2 or out["d"] < 2:
        raise ValueError("invalid prime-vector state")
    return out


def load_state() -> dict:
    if not state_path.exists() or state_path.stat().st_size == 0:
        return normalize(None)
    return normalize(json.loads(state_path.read_text(encoding="utf-8")))


def attach_hologram(out: dict) -> dict:
    keys = ["t", "pc", "n", "p", "c", "d"]
    coeffs = [int(out[k]) for k in keys]
    out["vector"] = coeffs
    out["hologram"] = {
        "encoding": "ordered-integer-coefficients",
        "keys": keys,
        "coeffs": coeffs,
        "reconstruct": True,
        "sha": False,
    }
    out["node"] = {
        "address": node_address,
        "capability": MODEL,
        "state_continuity": "persistent-file",
        "process_continuity": "host-dependent",
    }
    out["credential_value_present"] = False
    out["updated_at"] = int(time.time())
    return out


def step(out: dict) -> dict:
    out = normalize(out)
    out["t"] += 1
    out["pc"] = 0

    c = int(out["c"])
    d = int(out["d"])

    if c <= 2:
        out["p"] = 2
        out["n"] = max(1, int(out["n"]) + 1)
        out["c"] = 3
        out["d"] = 3
        out["pc"] = 1
        return attach_hologram(out)

    if c % 2 == 0:
        c += 1
    if d < 3 or d % 2 == 0:
        d = 3

    if d * d > c:
        out["p"] = c
        out["n"] = int(out["n"]) + 1
        out["c"] = c + 2
        out["d"] = 3
        out["pc"] = 1
    elif c % d == 0:
        out["c"] = c + 2
        out["d"] = 3
    else:
        out["c"] = c
        out["d"] = d + 2

    return attach_hologram(out)


descriptor = {
    "schema": 1,
    "model": "UVTM_PUBLIC_COMPUTE_NODE_DESCRIPTOR",
    "address": node_address,
    "capability": MODEL,
    "interval_seconds": str(Decimal(1) / hz_dec),
    "state_file": str(state_path),
    "halt_file": str(halt_path),
    "credential_value_present": False,
    "notes": "Public compute node descriptor only; it contains no exchange credentials or private keys.",
}
atomic_json(descriptor_path, descriptor)

state = load_state()
next_deadline = time.monotonic()

while not halt_path.exists():
    if max_ticks > 0 and int(state["t"]) >= max_ticks:
        break

    state = step(state)
    atomic_json(state_path, state)
    print(json.dumps(state, sort_keys=True, separators=(",", ":"), ensure_ascii=False), flush=True)

    if max_ticks > 0 and int(state["t"]) >= max_ticks:
        break

    next_deadline += interval
    delay = next_deadline - time.monotonic()
    if delay > 0:
        time.sleep(delay)
    else:
        next_deadline = time.monotonic()
PY
