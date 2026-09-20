#!/bin/sh
set -eu
BASE=$(CDPATH= cd "$(dirname "$0")" && pwd)
UNIT=blue-pleiadian-all-residents.service
DEST=/etc/systemd/system/$UNIT
install -m 0644 "$BASE/$UNIT" "$DEST"
mkdir -p /var/lib/blue-pleiadian-stars
systemctl daemon-reload
systemctl enable --now "$UNIT"
systemctl --no-pager --full status "$UNIT" || true
