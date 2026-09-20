#!/bin/sh
set -eu
cd "$(dirname "$0")"
mkdir -p runtime
docker compose up -d --build
docker compose ps
