# All Resident Loops / Daemon Supervisor

This supervisor runs every resident model currently deployed in the repository in an isolated state directory.

Managed loops:

1. `exact_solver` — `solver.py`, the full exact finite-zeta / hologram / C2 graph system.
2. `exact_2kb` — `EXACT_PLEIADES_2KB_ONE_LINER.sh`.
3. `v9_exact` — `v9_exact/UNIVERSAL_COSMIC_PRIME_HOLOGRAM_TM_v9_EXACT.sh`.
4. `riemann_log_product` — `RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh`.
5. `riemann_godel_rational` — `RIEMANN_GODEL_RATIONAL_SPECTRAL_HOLOGRAM_TM.sh`.
6. `prime_index_hologram` — `PRIME_INDEX_HOLOGRAM_TM.sh`.

Each loop has its own directory below `DATA_ROOT`, so scripts that use `state.json` cannot overwrite one another.

## Foreground supervisor

```sh
chmod +x deployment/all_residents/run_all.sh
INTERVAL=1 deployment/all_residents/run_all.sh
```

Default state root: `runtime_all_residents/`.

## Portable daemon mode

```sh
chmod +x deployment/all_residents/daemon.sh
deployment/all_residents/daemon.sh start
deployment/all_residents/daemon.sh status
deployment/all_residents/daemon.sh stop
```

This uses `nohup` and a PID file and is useful on systems without systemd.

## systemd daemon

The service assumes the repository is installed at `/opt/blue-pleiadian-stars`.

```sh
sudo mkdir -p /opt/blue-pleiadian-stars /var/lib/blue-pleiadian-stars
# place/clone this repository at /opt/blue-pleiadian-stars
sudo sh deployment/all_residents/install_systemd.sh
```

Then:

```sh
systemctl status blue-pleiadian-all-residents.service
journalctl -u blue-pleiadian-all-residents.service -f
sudo systemctl restart blue-pleiadian-all-residents.service
sudo systemctl disable --now blue-pleiadian-all-residents.service
```

`Restart=always` lets systemd restart the supervisor if it exits. `KillMode=control-group` ensures the child resident loops are stopped with the daemon.

## Healthcheck

```sh
python3 deployment/all_residents/healthcheck.py runtime_all_residents
```

The healthcheck verifies that all six state files exist and checks their central reversible/exactness invariants.

## Scope

The daemon makes the finite computations resident; it does not turn a formal direct limit into a physically completed infinity. The Riemann-related models retain their explicit `RH_proved: false` claims, and the prime-index loop is exact but computationally expensive for very large `n`.

GitHub Actions performs only a finite smoke test. GitHub itself is not the always-on host; true residency occurs on the Linux/systemd, Docker, or local host where the supervisor is running.
