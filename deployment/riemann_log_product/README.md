# RIEMANN_LOG_PRODUCT_HOLOGRAM_TM deployment

This deployment runs `RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh` once per second by default and persists `state.json` outside the container.

## Docker Compose

```sh
cd deployment/riemann_log_product
docker compose up -d --build
```

Persistent state is written to `deployment/riemann_log_product/runtime/state.json`.

Stop:

```sh
docker compose down
```

Follow output:

```sh
docker compose logs -f
```

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

The runtime loop advances `tick` indefinitely while retaining the exact symbolic invariants `x=1/2`, `s=3/4`, no preset zero decimals, reversible holographic encoding, no floating-point core, and no application SHA. The symbolic `Root_n(HardyZ(log A))` objects define zero ordinates formally; this does not prove the Riemann hypothesis.
