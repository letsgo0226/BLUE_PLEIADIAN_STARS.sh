#!/usr/bin/env python3
import json,sys,math
s=json.load(open(sys.argv[1] if len(sys.argv)>1 else "/data/state.json"))
T=lambda x:x>1 and (x==2 or x%2 and all(x%d for d in range(3,math.isqrt(x)+1,2)))
assert s["model"]=="PRIME_INDEX_HOLOGRAM_TM"
assert s["n"]>=1 and s["pi_p"]==s["n"] and s["ordinal_exact"] is True
assert s["prime"] is True and T(s["p"])
assert sum(T(k) for k in range(2,s["p"]+1))==s["n"]
assert s["exact"]=={"float":False,"sha":False}
assert s["claims"]=={"exact_integer":True,"elementary_scalar_closed_form":False,"RH_proved":False}
core={k:v for k,v in s.items() if k not in ("hologram","exact")}
assert json.loads(bytes(s["hologram"]["coeff"]).decode())==core
assert s["hologram"]["reconstruct"] is True
print("healthy",s["n"],s["p"])
