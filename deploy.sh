#!/bin/bash
set -e

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

SERVICE_NAME="diandian"
WORKING_DIR="/root/dian-dian"
BACKEND_DIR="$WORKING_DIR/backend"
FRONTEND_DIR="$WORKING_DIR/frontend"
SERVICE_FILE="/etc/systemd/system/$SERVICE_NAME.service"
NODE_VERSION=$(nvm current)
NODE_PATH="$HOME/.nvm/versions/node/$NODE_VERSION/bin/node"
NPX_PATH="$HOME/.nvm/versions/node/$NODE_VERSION/bin/npx"

if [ -z "$NODE_VERSION" ]; then
    echo "Error: Node.js not found. Install it via nvm."
    exit 1
fi

echo "Using Node.js $NODE_VERSION"
cd "$WORKING_DIR" || exit 1

# ── Pull latest code ──
echo ""
echo "=== Pulling latest code ==="
git pull origin master

# ── Build everything while service is still running ──
echo ""
echo "=== Building backend ==="
cd "$BACKEND_DIR"
npm ci
npm run build

echo ""
echo "=== Running migrations ==="
$NPX_PATH drizzle-kit migrate

npm prune --omit=dev

echo ""
echo "=== Building frontend ==="
cd "$FRONTEND_DIR"
npm ci
$NPX_PATH expo export --platform web

# ── Quick restart — service is down for ~1 second ──
echo ""
echo "=== Restarting service ==="

cat <<EOF | sudo tee $SERVICE_FILE > /dev/null
[Unit]
Description=Dian Dian API + Frontend
After=network.target postgresql.service

[Service]
WorkingDirectory=$BACKEND_DIR
ExecStart=$NODE_PATH $BACKEND_DIR/dist/index.js
Restart=always
RestartSec=5
User=root
Group=root
Environment=NODE_ENV=production

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl restart $SERVICE_NAME

echo ""
echo "=== Deploy complete ==="
sudo systemctl status $SERVICE_NAME --no-pager
