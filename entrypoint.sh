#!/bin/sh
set -e
: "${UUID:?UUID env is required}"
WSPATH="${WS_PATH:-/ws}"
PORT="${PORT:-8080}"
mkdir -p /etc/xray
cat > /etc/xray/config.json <<EOF
{
  "log": { "loglevel": "warning" },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": $PORT,
      "protocol": "vless",
      "settings": {
        "clients": [ { "id": "$UUID" } ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": { "path": "$WSPATH" }
      }
    }
  ],
  "outbounds": [ { "protocol": "freedom" } ]
}
EOF
exec /usr/bin/xray run -config /etc/xray/config.json
