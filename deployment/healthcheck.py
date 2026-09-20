#!/usr/bin/env python3
import json, sys
from pathlib import Path

p = Path(sys.argv[1] if len(sys.argv) > 1 else "/data/state.json")
if not p.exists():
    raise SystemExit(1)

x = json.loads(p.read_text(encoding="utf-8"))
ok = (
    x.get("hologram", {}).get("reconstruct") is True
    and x.get("symmetry", {}).get("graph_automorphism") is True
    and x.get("invariants", {}).get("sha_used") is False
)
raise SystemExit(0 if ok else 1)
