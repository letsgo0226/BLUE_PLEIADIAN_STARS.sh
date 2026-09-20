#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p runtime
chmod +x ../../RIEMANN_LOG_PRODUCT_HOLOGRAM_TM.sh resident_loop.sh
docker compose up -d --build
docker compose ps
