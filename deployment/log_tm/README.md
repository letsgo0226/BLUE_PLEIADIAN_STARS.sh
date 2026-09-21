# UHEF LOG(TM) deployment

This deployment runs the public `LOG_TM.sh` kernel as a persistent singleton at a deadline-corrected 1 Hz cadence.

The formal kernel keeps the reversible prime-vector TM and adds the UHEF metadata:

`u=1/n=rho=s-1`

`N:(Schw,Stirling,Riemann)->1`

`A=B <=> A/B=1 <=> Log=0 mod 2pi i Z`

`[D(exp(AC(Log(E(H))))]=[H]`

These are formal normalization/equivalence coordinates. They do not assert that Schwarzschild geometry, Stirling asymptotics, and the Riemann zeta function are physically identical, nor that this is a proved physical Theory of Everything.

## Start

```sh
git pull
chmod +x deployment/log_tm/daemon.sh
D="$HOME/.local/state/blue-pleiadian-stars/log-tm"
mkdir -p "$D"
rm -f "$D/HALT"
nohup deployment/log_tm/daemon.sh >>"$HOME/uhef-log-tm.log" 2>&1 &
```

## Inspect

```sh
tail -f "$HOME/uhef-log-tm.log"
cat "$HOME/.local/state/blue-pleiadian-stars/log-tm/state.json"
```

## Stop

```sh
touch "$HOME/.local/state/blue-pleiadian-stars/log-tm/HALT"
```

The daemon stores state locally and uses a singleton lock with stale-lock recovery. The scheduler advances its monotonic deadline by one second per cycle, avoiding the old `work + sleep 1` drift. If a cycle overruns its deadline, the next sleep is zero; this is one tick per scheduled second when the host can keep up, not a real-time guarantee.

On iOS/iSH, iOS may suspend the app, so this cannot guarantee physical 24/7 execution. Persistent state permits logical continuation after restart.
