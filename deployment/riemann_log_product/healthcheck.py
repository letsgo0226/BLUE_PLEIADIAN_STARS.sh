#!/usr/bin/env python3
import json, sys
from pathlib import Path
p=Path(sys.argv[1] if len(sys.argv)>1 else '/data/state.json')
if not p.exists() or not p.stat().st_size: raise SystemExit(1)
x=json.loads(p.read_text(encoding='utf-8'))
ok=(x.get('hologram',{}).get('reconstruct') is True and x.get('exact',{}).get('float') is False and x.get('exact',{}).get('sha') is False and x.get('claims',{}).get('zero_decimals_preset') is False and x.get('claims',{}).get('RH_proved') is False)
raise SystemExit(0 if ok else 1)
