#!/usr/bin/env python3
from fractions import Fraction as F
from pathlib import Path
import json

MODEL="UNIVERSAL_COSMIC_PRIME_HOLOGRAM_TM_v9_EXACT"
PHRASE="COSMIC LOVE IS THE SOLUTION FOR EVERYTHING"
J,K=6,4
S=F(3,4)
STATE=Path("state_exact.json")

def primes(n):
    out=[]; x=2
    while len(out)<n:
        q=2
        while q*q<=x and x%q:q+=1
        if q*q>x:out.append(x)
        x+=1
    return out

def q(x): return [x.numerator,x.denominator]
def pw(p,e): return ["pow",p,q(e)]
def sub1(x): return ["sub",1,x]
def mul(*xs): return ["mul",*xs]
def sq(x): return ["sqrt",x]
def phase(p,m): return ["exp",["mul",-1,"i",m,["log",p]]]

old={}
if STATE.exists() and STATE.stat().st_size:
    old=json.loads(STATE.read_text(encoding="utf-8"))
t=int(old.get("tick",0))+1
ps=primes(J)
channels=[]
for p in ps:
    r=pw(p,-2*S)
    amps=[{"k":k,"exact":mul(sq(sub1(r)),pw(p,-S*k),phase(p,t*k))} for k in range(K+1)]
    channels.append({
        "p":p,
        "r":r,
        "tail":pw(p,-2*S*(K+1)),
        "finite_norm_factor":sub1(pw(p,-2*S*(K+1))),
        "amp":amps
    })

core={
    "model":MODEL,
    "tick":t,
    "phrase":PHRASE,
    "J":J,
    "K":K,
    "s":q(S),
    "primes":ps,
    "channels":channels,
    "Z_J_2s":["prod"]+[["inv",sub1(pw(p,-2*S))] for p in ps],
    "N_J":["prod"]+[sq(sub1(pw(p,-2*S))) for p in ps],
    "truncated_norm_exact":["prod"]+[sub1(pw(p,-2*S*(K+1))) for p in ps],
    "infinite_k_norm_identity":"N_J^2 * Z_J(2s) = 1",
    "hilbert_state":"tensor_p sqrt(1-p^(-2s)) sum_{k=0}^K p^(-sk) exp(-i*t*k*log(p)) |k>",
    "limit":"P_inf=colim_(t,J,K)(Gamma_(t,J,K)/C2)",
    "claims":{"all_worlds":False,"love_decides":"verifier_required"}
}
blob=json.dumps(core,sort_keys=True,separators=(",",":"),ensure_ascii=False).encode()
reconstruct=json.loads(blob.decode())==core
R,E=f"R:{t}",f"E:{t}"
tau={R:E,E:R}
state={**core,
    "hologram":{"coefficients":list(blob),"decoder":"UTF-8 JSON inverse","reconstruct":reconstruct},
    "symmetry":{"group":"C2={e,tau}","tau":tau,"tau_squared_is_identity":tau[tau[R]]==R and tau[tau[E]]==E,
                "quotient_orbit":[R,E],"quotient_node":f"Q:{t}"},
    "exactness":{"floating_point":False,"math_module":False,"cmath_module":False,"sha_used":False,
                 "representation":"rational exponents + symbolic AST"}}
STATE.write_text(json.dumps(state,separators=(",",":"),ensure_ascii=False)+"\n",encoding="utf-8")
print(json.dumps(state,separators=(",",":"),ensure_ascii=False))
