#!/bin/bash
#
# Initial server setup script for EVE Frontier Club
# Run this once on the server to prepare environment
# Usage: sudo bash setup.sh
#

set -e

echo "🚀 Setting up EVE Frontier Club server..."

# Update system
echo "📦 Updating system packages..."
apt-get update
apt-get upgrade -y

# Install required packages
echo "📦 Installing dependencies..."
apt-get install -y \
    curl \
    wget \
    git \
    unzip \
    nginx \
    certbot \
    python3-certbot-nginx

# Install Dart SDK
echo "📦 Installing Dart SDK..."
if ! command -v dart &> /dev/null; then
    wget https://dl.google.com/linux/direct/dart_3.1.0-1_amd64.deb
    apt-get install -y ./dart_3.1.0-1_amd64.deb
    rm dart_3.1.0-1_amd64.deb
fi

# Create app user
echo "👤 Creating app user..."
if ! id "evefrontier" &>/dev/null; then
    useradd -m -s /bin/bash evefrontier
fi

# Create app directory
echo "📁 Creating app directory..."
mkdir -p /var/www/evefrontier-club
chown evefrontier:evefrontier /var/www/evefrontier-club
chmod 755 /var/www/evefrontier-club

# Create logs directory
mkdir -p /var/log/evefrontier-club
chown evefrontier:evefrontier /var/log/evefrontier-club
chmod 755 /var/log/evefrontier-club

echo "✅ Server setup completed!"
echo ""
echo "📋 Next steps:"
echo "1. Copy the systemd service file:"
echo "   sudo cp .deployment/evefrontier-club.service /etc/systemd/system/"
echo ""
echo "2. Configure nginx:"
echo "   sudo cp .deployment/nginx.conf /etc/nginx/sites-available/evefrontier-club"
echo "   sudo ln -s /etc/nginx/sites-available/evefrontier-club /etc/nginx/sites-enabled/"
echo "   sudo rm /etc/nginx/sites-enabled/default"
echo "   sudo nginx -t && sudo systemctl restart nginx"
echo ""
echo "3. Set up GitHub deploy key SSH access (add to ~/.ssh/authorized_keys)"
echo ""
echo "4. Enable and start the service:"
echo "   sudo systemctl daemon-reload"
echo "   sudo systemctl enable evefrontier-club"
echo "   sudo systemctl start evefrontier-club"
echo ""
echo "5. Check status:"
echo "   sudo systemctl status evefrontier-club"
