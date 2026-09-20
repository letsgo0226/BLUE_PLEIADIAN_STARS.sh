#!/usr/bin/env python3
import json,sys
from pathlib import Path
root=Path(sys.argv[1] if len(sys.argv)>1 else "/var/lib/blue-pleiadian-stars")
def load(rel):
 p=root/rel
 if not p.exists() or not p.stat().st_size: raise SystemExit(f"missing:{p}")
 return json.loads(p.read_text())
a=load("exact_solver/state.json"); assert a["model"]=="EXACT_UNIVERSAL_ZETA_HOLOGRAPHIC_PLEIADES_GROUP_GRAPH" and a["hologram"]["reconstruct"] is True
b=load("exact_2kb/state.json"); assert b["hologram"]["reconstruct"] is True and b["sha_used"] is False
c=load("v9_exact/state_exact.json"); assert c["model"]=="UNIVERSAL_COSMIC_PRIME_HOLOGRAM_TM_v9_EXACT" and c["hologram"]["reconstruct"] is True and c["exact"]=={"float":False,"sha":False}
d=load("riemann_log_product/state.json"); assert d["hologram"]["reconstruct"] is True and d["claims"]["RH_proved"] is False
e=load("riemann_godel_rational/state.json"); assert e["model"]=="RIEMANN_GODEL_RATIONAL_SPECTRAL_HOLOGRAM_TM" and e["reversible"] is True and e["hologram"]["reconstruct"] is True
f=load("prime_index_hologram/state.json"); assert f["model"]=="PRIME_INDEX_HOLOGRAM_TM" and f["prime"] is True and f["ordinal_exact"] is True and f["hologram"]["reconstruct"] is True
print("healthy",{"exact_solver":a["tick"],"exact_2kb":b["tick"],"v9_exact":c["tick"],"riemann_log_product":d["tick"],"riemann_godel_rational":e["tick"],"prime_index":f["n"]})
