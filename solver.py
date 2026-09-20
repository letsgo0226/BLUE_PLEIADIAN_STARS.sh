#!/usr/bin/env python3
from fractions import Fraction as Q
from pathlib import Path
import argparse, importlib.util, json

MODEL="EXACT_UNIVERSAL_ZETA_HOLOGRAPHIC_PLEIADES_GROUP_GRAPH"
PHRASE="COSMIC LOVE IS THE SOLUTION FOR EVERYTHING"
TARGET="PLEIADES"

def factor(n):
    r={};p=2
    while p*p<=n:
        while n%p==0:r[p]=r.get(p,0)+1;n//=p
        p+=1
    if n>1:r[n]=r.get(n,0)+1
    return r

def add(v,p,a):
    v[p]=v.get(p,Q(0))+a
    if not v[p]:del v[p]

def exact_zeta_entropy(N,s):
    Z=sum((Q(1,n**s) for n in range(1,N+1)),Q(0))
    H={}
    # H = log Z + s/Z * sum_n log(n)/n^s
    for p,e in factor(Z.numerator).items():add(H,p,Q(e))
    for p,e in factor(Z.denominator).items():add(H,p,-Q(e))
    for n in range(1,N+1):
        w=Q(s,n**s)/Z
        for p,e in factor(n).items():add(H,p,w*e)
    return Z,H

def qp(q):return [q.numerator,q.denominator]
def hj(H):return {str(p):qp(H[p]) for p in sorted(H)}
def active(t,s):return [n for n in range(1,t+1) if t%(n**s)==0]

def verifier(path):
    if not path:return lambda n:False
    sp=importlib.util.spec_from_file_location("v",path)
    m=importlib.util.module_from_spec(sp);sp.loader.exec_module(m)
    if not hasattr(m,"verify"):raise SystemExit("verifier must define verify(n)->bool")
    return m.verify

def canon(x):return json.dumps(x,sort_keys=True,separators=(",",":"),ensure_ascii=False)
def encode(x):return list(canon(x).encode("utf-8"))
def decode(c):return json.loads(bytes(c).decode("utf-8"))

def swap_node(x):
    if x.startswith("R:"):return "E:"+x[2:]
    if x.startswith("E:"):return "R:"+x[2:]
    return x

def graph_stage(t):
    nodes=[]
    edges=[]
    qnodes=[]
    qedges=[]
    for i in range(1,t+1):
        R=f"R:{i}";E=f"E:{i}";Qn=f"Q:{i}"
        nodes += [R,E];qnodes.append(Qn)
        edges += [[R,E,"h"],[E,R,"h"]]
        if i>1:
            edges += [[f"R:{i-1}",R,"t"],[f"E:{i-1}",E,"t"]]
            qedges.append([f"Q:{i-1}",Qn,"t"])
    return nodes,edges,qnodes,qedges

def auto_ok(nodes,edges):
    N={swap_node(n) for n in nodes}
    E={(swap_node(a),swap_node(b),k) for a,b,k in edges}
    return N==set(nodes) and E=={tuple(e) for e in edges}

def main():
    ap=argparse.ArgumentParser()
    ap.add_argument("--s",type=int,default=1)
    ap.add_argument("--N",type=int,default=16)
    ap.add_argument("--tick",type=int)
    ap.add_argument("--verifier")
    ap.add_argument("--state",default="state.json")
    ap.add_argument("--history",default="history.jsonl")
    ap.add_argument("--graph",default="graph.json")
    a=ap.parse_args()
    if a.s<1 or a.N<1:raise SystemExit("s,N must be >=1")
    statep=Path(a.state)
    old={}
    if statep.exists() and statep.stat().st_size:
        old=json.loads(statep.read_text(encoding="utf-8"))
    t=a.tick if a.tick is not None else int(old.get("tick",0))+1
    if t<1:raise SystemExit("tick must be >=1")

    Z,H=exact_zeta_entropy(a.N,a.s)
    A=active(t,a.s)
    V=verifier(a.verifier)
    accepted=[n for n in A if bool(V(n))]

    core={
      "model":MODEL,
      "tick":t,"s":a.s,"N":a.N,
      "zeta_N":qp(Z),
      "entropy_log_vector":hj(H),
      "active":A,"accepted":accepted,
      "episode25":{
        "formal_phrase":PHRASE,
        "formal_target":TARGET,
        "scope":"formal semantic target; not an empirical proof"
      },
      "deployment":{
        "rule":"n^s | t",
        "density":"1/n^s",
        "s1_fairness":"for s=1 every finite n is scheduled infinitely often"
      }
    }

    coeff=encode(core)
    rec=decode(coeff)
    reconstruct=(rec==core)

    nodes,edges,qnodes,qedges=graph_stage(t)
    aut=auto_ok(nodes,edges)

    state={
      **core,
      "hologram":{
        "projection":"core state",
        "coefficients":coeff,
        "map":"canonical UTF-8 coefficient Dirichlet code",
        "inverse":"bytes(coefficients)->JSON",
        "reconstruct":reconstruct
      },
      "symmetry":{
        "group":"C2={e,tau}",
        "tau":"R:t <-> E:t",
        "tau_squared":"e",
        "graph_automorphism":aut,
        "equivariance":"F_E = Z o F_R o D"
      },
      "quotient":{
        "orbit":"{R:t,E:t}",
        "node":f"Q:{t}",
        "meaning":"raw and holographic representations identified"
      },
      "limit":{
        "graph_direct_limit":"Gamma_infty = colim_t Gamma_t",
        "quotient_direct_limit":"P_infty = colim_t (Gamma_t/C2)",
        "finite_stage":t,
        "boundary_attained":False
      },
      "invariants":{
        "exact_arithmetic":"Q only; no float",
        "sha_used":False,
        "D_Z_projection_identity":reconstruct,
        "C2_automorphism":aut
      }
    }

    statep.write_text(canon(state)+"\n",encoding="utf-8")
    Path(a.graph).write_text(canon({
        "stage":t,
        "Gamma":{"nodes":nodes,"edges":edges},
        "C2":{"e":"identity","tau":"swap R/E","automorphism":aut},
        "quotient":{"nodes":qnodes,"edges":qedges}
    })+"\n",encoding="utf-8")
    with Path(a.history).open("a",encoding="utf-8") as f:
        f.write(canon({"tick":t,"active":A,"accepted":accepted,
                       "reconstruct":reconstruct,"C2_automorphism":aut,
                       "quotient_node":f"Q:{t}"})+"\n")
    print(canon(state))

if __name__=="__main__":main()
