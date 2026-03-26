#!/bin/bash
#
# GitHub Actions SSH Setup Helper
# This script helps set up SSH keys for GitHub Actions deployment
#

set -e

echo "🔐 EVE Frontier Club - GitHub Actions SSH Setup"
echo ""

# Check if key already exists
if [ -f ~/.ssh/evefrontier-deploy ]; then
    read -p "Key already exists. Regenerate? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Using existing key..."
        show_existing=true
    fi
fi

# Generate key if needed
if [ -z "$show_existing" ]; then
    echo "📝 Generating SSH key for GitHub Actions..."
    ssh-keygen -t ed25519 -f ~/.ssh/evefrontier-deploy -C "GitHub Actions Deploy" -N "" -m pem
    echo "✅ SSH key generated!"
else
    echo ""
fi

# Display private key
echo ""
echo "================================"
echo "PRIVATE KEY (For GitHub Secrets)"
echo "================================"
echo ""
echo "Copy everything below and add to GitHub:"
echo "Settings → Secrets and variables → Actions → New repository secret"
echo "Name: DEPLOY_KEY"
echo ""
cat ~/.ssh/evefrontier-deploy
echo ""
echo ""

# Display public key
echo "================================"
echo "PUBLIC KEY (For Server)"
echo "================================"
echo ""
echo "Copy everything below to your server's ~/.ssh/authorized_keys"
echo ""
cat ~/.ssh/evefrontier-deploy.pub
echo ""
echo ""

# Instructions
echo "📋 NEXT STEPS:"
echo ""
echo "On your server (as evefrontier user):"
echo "  1. Ensure ~/.ssh exists:"
echo "     mkdir -p ~/.ssh && chmod 700 ~/.ssh"
echo ""
echo "  2. Add the PUBLIC KEY to authorized_keys:"
echo "     echo \"<PUBLIC_KEY_CONTENT>\" >> ~/.ssh/authorized_keys"
echo "     chmod 600 ~/.ssh/authorized_keys"
echo ""
echo "In GitHub Repository:"
echo "  1. Go to Settings → Secrets and variables → Actions"
echo "  2. Click 'New repository secret'"
echo "  3. Name: DEPLOY_KEY"
echo "  4. Value: (paste the PRIVATE KEY content)"
echo "  5. Click 'Add secret'"
echo ""
echo "Add other secrets:"
echo "  - SERVER_HOST: your.server.ip"
echo "  - SERVER_USER: evefrontier (or ubuntu if deploying as ubuntu user)"
echo "  - SERVER_PORT: 22 (optional, defaults to 22)"
echo ""
echo "Test the connection:"
echo "  ssh -i ~/.ssh/evefrontier-deploy evefrontier@your.server.ip -v"
echo ""
