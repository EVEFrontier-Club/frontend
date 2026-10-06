# [INTERNAL - MAINTAINERS ONLY] Operations & Troubleshooting Guide

> ⚠️ This document is for project maintainers only.
> 
> **Contributors**: See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for local development.

# Server Monitoring & Troubleshooting Guide

## Quick Diagnostics

### Check Overall Health
```bash
# Service status
sudo systemctl status evefrontier-club

# Quick system check
free -h && df -h && top -b -n 1 | head -15
```

### View Recent Logs
```bash
# Last 50 lines
sudo journalctl -u evefrontier-club -n 50

# Follow logs in real-time
sudo journalctl -u evefrontier-club -f

# Last 30 minutes
sudo journalctl -u evefrontier-club --since "30 minutes ago"

# With detailed source info
sudo journalctl -u evefrontier-club -o verbose

# Pretty JSON format
sudo journalctl -u evefrontier-club -o json-pretty
```

## Performance Monitoring

### Memory Usage
```bash
# Overall memory
free -h

# Per-process breakdown
ps aux --sort=-%mem | head -10

# Watch memory in real-time
watch -n 1 'free -h && echo "---" && ps aux --sort=-%mem | head -5'

# Check if process was killed (OOM)
dmesg | grep -i oom
```

### CPU Usage
```bash
# Top CPU consumers
top -b -n 1 | sort -k3 -nr | head -10

# Watch CPU in real-time
watch -n 1 'top -b -n 1 | head -20'

# System CPU info
nproc                    # Number of CPUs
lscpu                    # CPU details
```

### Disk Usage
```bash
# Overall disk usage
df -h

# Per directory breakdown
du -sh /var/www/evefrontier-club/*
du -sh /var/log/evefrontier-club

# Find large files
find /var/www/evefrontier-club -type f -size +10M
```

## Service Management

### Start/Stop/Restart
```bash
# Start service
sudo systemctl start evefrontier-club

# Stop service
sudo systemctl stop evefrontier-club

# Restart service (deployment uses this)
sudo systemctl restart evefrontier-club

# Reload configuration without restart
sudo systemctl reload evefrontier-club

# Enable on boot
sudo systemctl enable evefrontier-club

# Disable from autostart
sudo systemctl disable evefrontier-club
```

### View Service Configuration
```bash
# Show active configuration
systemctl cat evefrontier-club

# Show environment
systemctl show evefrontier-club --all | grep -i env

# Show resource limits
systemctl show evefrontier-club --all | grep -i limit
```

## Nginx Monitoring

### Check Nginx Status
```bash
# Service status
sudo systemctl status nginx

# Reload configuration
sudo nginx -t && sudo systemctl reload nginx

# View active connections
ss -tuln | grep LISTEN

# Monitor connections in real-time
watch -n 1 'ss -tuln | grep ":80"'
```

### Nginx Logs
```bash
# Access logs
sudo tail -f /var/log/nginx/access.log

# Error logs (most important)
sudo tail -f /var/log/nginx/error.log

# Count requests by status
sudo tail -100 /var/log/nginx/access.log | awk '{print $9}' | sort | uniq -c

# Top 10 slowest requests
sudo tail -1000 /var/log/nginx/access.log | sort -k4 -t' ' | tail -10
```

## Connectivity Testing

### Test Backend Connection
```bash
# Direct connection to app
curl http://127.0.0.1:8080

# Test with verbose output
curl -v http://127.0.0.1:8080

# Test with custom headers
curl -H "X-Forwarded-For: 1.2.3.4" http://127.0.0.1:8080
```

### Test Nginx Proxy
```bash
# Test public endpoint
curl -v http://localhost

# Test with all headers
curl -i http://localhost

# Measure response time
time curl -o /dev/null http://localhost
```

### Check Ports
```bash
# Port 8080 (App)
sudo ss -tuln | grep 8080

# Port 80 (Nginx HTTP)
sudo ss -tuln | grep ":80"

# Port 443 (Nginx HTTPS - if enabled)
sudo ss -tuln | grep ":443"

# All listening ports
sudo ss -tuln
```

## Debug Slow Performance

### Step 1: Identify Bottleneck
```bash
# Is it memory?
free -h

# Is it CPU?
top -b -n 1 | grep evefrontier

# Is it disk?
iostat -x 1 5

# Is it network?
iftop -B
```

### Step 2: Check Application
```bash
# View detailed logs
sudo journalctl -u evefrontier-club -o verbose -n 100

# Check memory limits
systemctl show evefrontier-club | grep -i memor

# Check for restarts (indicates crash)
systemctl status evefrontier-club | grep -i restart
```

### Step 3: Check System
```bash
# System load
uptime

# Context switches and interrupts
vmstat 1 5

# Network stats
netstat -s

# Check for errors
dmesg | tail -30
```

## Common Issues & Solutions

### Service Won't Start
```bash
# Check logs for error
sudo journalctl -u evefrontier-club -n 50

# Verify file permissions
ls -la /var/www/evefrontier-club

# Check if port is in use
sudo ss -tuln | grep 8080

# Fix: Restart service
sudo systemctl restart evefrontier-club
```

### Out of Memory (OOM) Killer
```bash
# Check for OOM events
dmesg | grep -i oom | tail -5

# Check current memory limit
systemctl show evefrontier-club | grep MemoryLimit

# Increase limit (edit service file, then restart):
sudo systemctl edit evefrontier-club
# Change: MemoryMax=256M to MemoryMax=512M
sudo systemctl daemon-reload
sudo systemctl restart evefrontier-club
```

### High CPU Usage
```bash
# Check what's consuming CPU
top -n 1 -b | grep evefrontier

# Profile with perf (if needed)
sudo perf top -p $(pidof dart)

# Check for infinite loops in logs
sudo journalctl -u evefrontier-club -f | grep -i loop
```

### Connection Refused
```bash
# Is app running?
sudo systemctl status evefrontier-club

# Is nginx running?
sudo systemctl status nginx

# Is port listening?
sudo ss -tuln | grep -E ":8080|:80"

# Fix DNS/networking
sudo systemctl restart networking
```

## Automated Monitoring Script

Save as `/tmp/monitor.sh`:

```bash
#!/bin/bash
while true; do
    clear
    echo "=== EVE Frontier Club Monitoring ==="
    echo "Time: $(date)"
    echo ""
    
    echo "Service Status:"
    systemctl status evefrontier-club --no-pager | head -3
    echo ""
    
    echo "Memory Usage:"
    free -h | head -3
    echo ""
    
    echo "CPU Usage:"
    ps aux | grep -E "COMMAND|evefrontier-club" | head -2
    echo ""
    
    echo "Recent Errors:"
    sudo journalctl -u evefrontier-club -n 3 --no-pager
    
    sleep 5
done
```

Run with:
```bash
bash /tmp/monitor.sh
```

## Alert Thresholds (1GB Server)

Set up alerts if:
- Memory usage > 800MB
- CPU usage > 90%
- Disk usage > 80%
- Service restarts > 3 in 1 hour
- Response time > 5 seconds

## Useful Aliases

Add to `~/.bashrc`:

```bash
alias applog='sudo journalctl -u evefrontier-club -f'
alias appstatus='sudo systemctl status evefrontier-club'
alias apprestart='sudo systemctl restart evefrontier-club'
alias appcheck='ps aux | grep evefrontier-club'
alias sysmon='watch -n 1 "free -h && echo --- && ps aux --sort=-%mem | head -5"'
```

## Emergency Restart Sequence

If system becomes unresponsive:

```bash
# 1. Stop everything
sudo systemctl stop evefrontier-club
sudo systemctl stop nginx

# 2. Wait 10 seconds
sleep 10

# 3. Clear resources
sync
echo 3 | sudo tee /proc/sys/vm/drop_caches

# 4. Restart in order
sudo systemctl start evefrontier-club
sudo systemctl start nginx

# 5. Monitor
sudo journalctl -u evefrontier-club -f
```
