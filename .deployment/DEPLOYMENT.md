# [INTERNAL - MAINTAINERS ONLY] Deployment Guide

> ⚠️ This document contains internal deployment procedures.
> 
> **Contributors**: See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for local development.

# EVE Frontier Club - Deployment Guide

This guide is for project maintainers only and covers deployment procedures.

## Architecture Overview

```
GitHub Actions (Build)
    ↓
    ├─ Compile Jaspr/Dart
    ├─ Build web assets
    └─ Create artifacts
    ↓
 SSH Deploy (rsync)
    ↓
  Server
    ├─ /var/www/evefrontier-club/ (Build artifacts)
    ├─ systemd service (evefrontier-club)
    └─ nginx reverse proxy (port 80/443)
```

## Prerequisites

- Ubuntu 20.04+ or Oracle Linux 8+
- Minimum 1GB RAM, 1 CPU (Oracle Free Tier)
- SSH access to server
- Git and Dart SDK installed on CI server (GitHub Actions handles this)

## Initial Server Setup

### 1. Run Setup Script

```bash
# On your development machine:
git clone git@github.com:EVEFrontier-Club/frontend.git
cd frontend

# Copy setup script to server
scp .deployment/setup.sh ubuntu@your-server-ip:/tmp/

# SSH into server and run setup
ssh ubuntu@your-server-ip
sudo bash /tmp/setup.sh
```

### 2. Generate SSH Deploy Key

Generate a dedicated SSH key for CI/CD:

```bash
# On your local machine
ssh-keygen -t ed25519 -f ~/.ssh/evefrontier-deploy -C "GitHub Actions Deploy" -N ""

# Copy to server
ssh-copy-id -i ~/.ssh/evefrontier-deploy.pub -p 22 evefrontier@your-server-ip
```

### 3. Add Secrets to GitHub

In your GitHub repository settings, add these secrets:

```
DEPLOY_KEY             → Contents of ~/.ssh/evefrontier-deploy (private key)
SERVER_HOST           → IP address or hostname of your server
SERVER_USER           → SSH user (usually 'evefrontier' or 'ubuntu')
SERVER_PORT           → SSH port (optional, defaults to 22)
BACKEND_URL           → http://localhost:8081 or your backend URL
```

### 4. Verify Connectivity

Test SSH connection:

```bash
# On your local machine
ssh -i ~/.ssh/evefrontier-deploy evefrontier@your-server-ip -p 22 'echo Connected!'
```

## Manual Deployment (Testing)

### Build Locally

```bash
cd frontend
dart pub get
dart pub run build_runner build --release
```

### Deploy via rsync

```bash
rsync -avz \
  -e "ssh -i ~/.ssh/evefrontier-deploy -p 22" \
  build/ \
  evefrontier@your-server-ip:/var/www/evefrontier-club/
```

### Restart Service

```bash
ssh -i ~/.ssh/evefrontier-deploy evefrontier@your-server-ip \
  'sudo systemctl restart evefrontier-club'
```

## Automated Deployment (GitHub Actions)

The CI/CD pipeline automatically:

1. **Builds** on every push to `main` branch
2. **Tests** Dart analysis
3. **Deploys** to production server via SSH
4. **Restarts** systemd service

### View Workflow Status

1. Go to your GitHub repository
2. Click "Actions" tab
3. View workflow runs and logs

## Server Management Commands

```bash
# Check status
sudo systemctl status evefrontier-club

# View logs
sudo journalctl -u evefrontier-club -f

# Restart service
sudo systemctl restart evefrontier-club

# Stop service
sudo systemctl stop evefrontier-club

# Start service
sudo systemctl start evefrontier-club

# Check memory/CPU usage
ps aux | grep dart

# Monitor system resources
free -h
top
```

## Nginx Management

```bash
# Test nginx config
sudo nginx -t

# Reload nginx
sudo systemctl reload nginx

# Restart nginx
sudo systemctl restart nginx

# View error logs
sudo tail -f /var/log/nginx/error.log

# View access logs
sudo tail -f /var/log/nginx/access.log
```

## SSL/TLS Setup (Let's Encrypt)

```bash
# Initial setup
sudo certbot certonly --webroot -w /var/www/evefrontier-club -d evefrontier.club -d www.evefrontier.club

# Enable HTTPS in nginx.conf and uncomment the 443 block

# Verify certificate
sudo certbot certificates

# Auto-renewal (runs daily)
sudo systemctl enable certbot.timer
sudo systemctl start certbot.timer
```

## Performance Optimization for 1GB RAM Server

The configuration already includes optimizations:

- **Memory limit**: 256MB per Jaspr process
- **CPU quota**: 80% limit
- **Nginx buffering**: Configured for low memory
- **Rate limiting**: Prevents abuse on limited resources
- **Gzip compression**: Reduces bandwidth

Monitor and adjust if needed:

```bash
# Monitor memory in real-time
watch free -h

# Check if OOM killer is triggering
dmesg | grep -i oom

# View systemd resource usage
systemd-cgtop
```

## Troubleshooting

### Service fails to start
```bash
sudo journalctl -u evefrontier-club -n 50
sudo systemctl status evefrontier-club
```

### Out of memory errors
```bash
# Check memory usage
free -h
ps aux --sort=-%mem | head -10

# Reduce memory limit in evefrontier-club.service
# MemoryMax=128M
```

### SSH deployment fails
```bash
# Test SSH key
ssh -i ~/.ssh/evefrontier-deploy evefrontier@your-server-ip -v

# Check server SSH logs
sudo tail -f /var/log/auth.log
```

### Website not accessible
```bash
# Check nginx status
sudo systemctl status nginx

# Check if backend is running
sudo systemctl status evefrontier-club

# Test connectivity to backend
curl http://127.0.0.1:8080

# Check firewall
sudo ufw status
```

## Scaling Considerations

If experiencing performance issues on 1GB RAM:

1. **Use CDN** for static assets
2. **Enable page caching** in nginx
3. **Monitor and optimize** database queries
4. **Consider horizontal scaling** (add more servers)
5. **Use PM2 or similar** for process management (future enhancement)

## Security Best Practices

- [ ] Keep server packages updated: `sudo apt-get update && apt-get upgrade`
- [ ] Use SSH keys only (disable password authentication)
- [ ] Configure firewall (UFW): `sudo ufw enable`
- [ ] Set up SSL/TLS certificates
- [ ] Monitor logs regularly
- [ ] Use strong SSH key passphrases
- [ ] Rotate deployment keys periodically
- [ ] Keep secrets secure in GitHub Actions

## Maintenance

### Regular Updates

```bash
# Update system
sudo apt-get update && sudo apt-get upgrade -y

# Update Dart SDK
sudo apt-get install --only-upgrade dart
```

### Backups

```bash
# Backup application directory
tar -czf ~/backups/evefrontier-club-$(date +%Y%m%d).tar.gz /var/www/evefrontier-club

# Backup nginx config
sudo cp -r /etc/nginx ~/backups/nginx-$(date +%Y%m%d)
```

## Support

For issues or questions:
1. Check GitHub Actions logs
2. Review systemd journal: `sudo journalctl -u evefrontier-club`
3. Check nginx error logs: `/var/log/nginx/error.log`
4. Open an issue in the GitHub repository
