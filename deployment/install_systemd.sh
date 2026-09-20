#!/bin/sh
set -eu

APP_DIR=/opt/pleiades
DATA_DIR=/var/lib/pleiades
USER_NAME=pleiades

if ! id "$USER_NAME" >/dev/null 2>&1; then
  adduser --system --group --home "$DATA_DIR" "$USER_NAME"
fi

mkdir -p "$APP_DIR" "$DATA_DIR"
cp -R ../solver.py ../verifier.py ../deployment "$APP_DIR/"
chown -R "$USER_NAME:$USER_NAME" "$APP_DIR" "$DATA_DIR"

cp systemd/pleiades.service /etc/systemd/system/pleiades.service
systemctl daemon-reload
systemctl enable --now pleiades.service
systemctl status pleiades.service --no-pager
