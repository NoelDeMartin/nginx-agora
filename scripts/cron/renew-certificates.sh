#!/usr/bin/env sh

# sudo crontab -e
# 0 0 * * 1 /var/www/nginx-agora/scripts/cron/renew-certificates.sh >> /var/log/cron-certbot.log

echo "[`date`] Renewing certificates..."
certbot renew --pre-hook "nginx-agora stop" --post-hook "nginx-agora start"

echo "[`date`] Certificates are up to date!"
echo ""
