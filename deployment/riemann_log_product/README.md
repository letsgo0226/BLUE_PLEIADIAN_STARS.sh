# RIEMANN_LOG_PRODUCT_HOLOGRAM_TM deployment

This deployment runs `RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh` once per second by default and persists `state.json` outside the container.

## One-command Docker deploy

```sh
cd deployment/riemann_log_product
chmod +x deploy.sh resident_loop.sh
./deploy.sh
```

Equivalent command:

```sh
docker compose up -d --build
```

Persistent state is written to `deployment/riemann_log_product/runtime/state.json`.

Check service health:

```sh
docker compose ps
```

Follow output:

```sh
docker compose logs -f
```

Stop:

```sh
docker compose down
```

The container healthcheck validates that the current state has reversible holographic reconstruction, no floating-point core, no application SHA, no preset Riemann-zero decimals, and does not claim RH is proved.

## Plain resident loop

From the repository root:

```sh
chmod +x RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh deployment/riemann_log_product/resident_loop.sh
ROOT="$PWD" DATA_DIR="$PWD/runtime" INTERVAL=1 deployment/riemann_log_product/resident_loop.sh
```

## systemd

Copy the repository to `/opt/blue-pleiadian-stars`, create `/var/lib/riemann-log-product`, then install `riemann-log-product.service` under `/etc/systemd/system/` and run:

```sh
sudo systemctl daemon-reload
sudo systemctl enable --now riemann-log-product.service
```

## CI

`.github/workflows/verify-riemann-log-product.yml` runs a finite smoke test on GitHub Actions and verifies `x=1/2`, `s=3/4`, reconstruction, symbolic-zero mode, and exactness flags.

The runtime loop advances `tick` indefinitely while retaining the exact symbolic invariants `x=1/2`, `s=3/4`, no preset zero decimals, reversible holographic encoding, no floating-point core, and no application SHA. The symbolic `Root_n(HardyZ(log A))` objects define zero ordinates formally; this does not prove the Riemann hypothesis.
