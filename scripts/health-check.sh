#!/usr/bin/env bash
# Probe a health endpoint and append timestamp,status,ms to a CSV log.
# Cron example: */5 * * * * /usr/local/bin/health-check.sh http://localhost/healthz
set -u
URL="${1:-http://localhost/healthz}"
LOG="${HEALTH_LOG:-/var/log/availability.csv}"

read -r code ms < <(curl -s -o /dev/null -w "%{http_code} %{time_total}\n" --max-time 15 "$URL" || echo "000 0")
[ -f "$LOG" ] || echo "timestamp,status,response_s" > "$LOG"
printf '%s,%s,%s\n' "$(date -u +%FT%TZ)" "$code" "$ms" >> "$LOG"
