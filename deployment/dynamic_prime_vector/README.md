# DYNAMIC_PRIME_VECTOR_TM resident deployment

`DYNAMIC_PRIME_VECTOR_TM.sh` is an exact-integer prime-vector state machine with an atomic persistent state file and a reversible ordered-integer "hologram" representation. The public deployment does **not** contain exchange credentials, API secrets, private keys, or trading execution.

## State

The canonical state fields are:

`(t, pc, n, p, c, d)`

- `t`: machine tick.
- `pc`: one-tick prime-commit pulse (`1` when a new prime is committed).
- `n`: committed prime ordinal.
- `p`: latest committed prime.
- `c`: current candidate.
- `d`: current trial divisor.

Each saved state includes:

- `vector=[t,pc,n,p,c,d]`
- a reversible ordered-integer `hologram`
- a public UVTM-style node address
- `credential_value_present=false`

All state writes use a temporary file plus `os.replace()`.

## Alpine / iSH / macOS shell

From the repository root:

```sh
chmod +x DYNAMIC_PRIME_VECTOR_TM.sh deployment/dynamic_prime_vector/daemon.sh
rm -f ~/.local/state/blue-pleiadian-stars/dynamic-prime-vector/HALT
HZ=1 nohup deployment/dynamic_prime_vector/daemon.sh \
  >> ~/dynamic-prime-vector.log 2>&1 &
```

Check:

```sh
cat ~/.local/state/blue-pleiadian-stars/dynamic-prime-vector/state.json
cat ~/.local/state/blue-pleiadian-stars/dynamic-prime-vector/channel.json
tail -20 ~/dynamic-prime-vector.log
```

Stop cleanly:

```sh
touch ~/.local/state/blue-pleiadian-stars/dynamic-prime-vector/HALT
```

Remove `HALT` only when you explicitly want to start again.

On iOS/iSH, a one-second loop is resident only while iOS permits the app/process to run. `nohup` cannot override iOS suspension. For actual 24/7 process continuity, use an always-on Linux/macOS/VPS host.

## Finite smoke run

```sh
tmp=$(mktemp -d)
STATE_FILE="$tmp/state.json" \
HALT_FILE="$tmp/HALT" \
NODE_DESCRIPTOR="$tmp/channel.json" \
MAX_TICKS=12 HZ=1000 \
sh DYNAMIC_PRIME_VECTOR_TM.sh
cat "$tmp/state.json"
```

## Linux systemd

Install the repository at `/opt/BLUE_PLEIADIAN_STARS.sh`, create a non-login `pleiades` service user, and create:

```sh
sudo mkdir -p /var/lib/blue-pleiadian-stars/dynamic-prime-vector
sudo chown -R pleiades:pleiades /var/lib/blue-pleiadian-stars
sudo cp deployment/systemd/dynamic-prime-vector.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable --now dynamic-prime-vector.service
```

Stop the machine semantically by creating its HALT file, or stop the service operationally with systemd.

## Communication-node interpretation

GitHub is the source/distribution/control plane. The host running this daemon is the execution node. The state file gives state continuity; the running process gives process continuity. They are different properties. Do not push one-second state updates to GitHub: keep high-frequency state local and publish only deliberate checkpoints or sanitized summaries.
