#!/usr/bin/env bash
# Baseline firewall: deny incoming by default, open 22/80/443 only.
# REVIEW the SSH rule for your admin IP before running.
set -eu
ADMIN_SSH="${ADMIN_SSH:-}"   # e.g. export ADMIN_SSH="203.0.113.7"
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
if [ -n "$ADMIN_SSH" ]; then
  sudo ufw allow from "$ADMIN_SSH" to any port 22 proto tcp
else
  echo "WARNING: no ADMIN_SSH set — allowing 22/tcp from anywhere. Restrict this." >&2
  sudo ufw allow 22/tcp
fi
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw --force enable
sudo ufw status numbered
