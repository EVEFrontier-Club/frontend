# [INTERNAL - MAINTAINERS ONLY] Deployment & Infrastructure

> ⚠️ **This directory contains internal infrastructure configuration.**
> 
> **For contributors**: See [`CONTRIBUTING.md`](../CONTRIBUTING.md) for local development.

## Overview

This directory contains build and deployment infrastructure configuration for project maintainers. 

## File Reference

| File | Purpose |
|------|---------|
| `.github/workflows/deploy.yml` | CI/CD automation workflow |
| `setup.sh` | Environment provisioning |
| `nginx.conf` | Web server configuration reference |
| `evefrontier-club.service` | Service management |
| `Dockerfile` / `docker-compose.yml` | Local development stack |
| `DEPLOYMENT.md` | Deployment procedures (internal) |
| `MONITORING.md` | Operations guide (internal) |

## For Contributors

Start here: [`CONTRIBUTING.md`](../CONTRIBUTING.md)

Quick local setup:
```bash
dart pub get
dart run jaspr:serve
# Open http://localhost:8080
```

Local full-stack testing:
```bash
docker-compose up
# Visit http://localhost
```

## For Project Maintainers

Production deployment information is maintained separately and not documented in the public repository for security reasons.

Key principles:
- Keep infrastructure details private
- Use GitHub Secrets for sensitive data
- Document only what contributors need to know
- Security through obscurity for infrastructure

## Building for Production

```bash
dart pub get && dart run build_runner build --release
```

This generates optimized web assets ready for deployment.

## Questions?

- **Contributing**: See [CONTRIBUTING.md](../CONTRIBUTING.md)
- **Bugs**: Open an [issue](https://github.com/EVEFrontier-Club/frontend/issues)
- **Discussions**: Join [discussions](https://github.com/EVEFrontier-Club/frontend/discussions)

## 🐳 Docker Support (Optional)

Test deployment locally:
```bash
docker-compose up
```

Access at `http://localhost/`

## 🔒 Security

The deployment includes:
- SSH key-based authentication
- Network isolation
- Resource limits (prevent OOM)
- Security headers in nginx
- Rate limiting
- CORS protection

**Important**: Never commit secrets or private keys to the repository.

## 📊 Monitoring

Monitor deployment on server:
```bash
# Real-time status
watch -n 1 'systemctl status evefrontier-club'

# Memory usage
watch free -h

# Service logs
sudo journalctl -u evefrontier-club -f --lines=50
```

## 🆘 Common Issues

### Deployment fails
1. Check GitHub Actions logs
2. Verify SSH key on server: `cat ~/.ssh/authorized_keys`
3. Test SSH connection: `ssh -i ~/.ssh/evefrontier-deploy ubuntu@your-server-ip`

### Service won't start
```bash
sudo journalctl -u evefrontier-club -n 20
sudo systemctl status evefrontier-club
```

### Out of memory
```bash
free -h
ps aux --sort=-%mem | head -5
```

Service is limited to 256MB, adjust in `.deployment/evefrontier-club.service` if needed.

### Nginx errors
```bash
sudo nginx -t
sudo systemctl restart nginx
sudo tail -f /var/log/nginx/error.log
```

## ✅ Verification Checklist

After deployment:
- [ ] GitHub Actions workflow completes successfully
- [ ] Server logs show successful deployment
- [ ] Website accessible at server IP/domain
- [ ] Frontend loads without errors
- [ ] API calls to backend work
- [ ] No memory/CPU warnings in logs

## 🚀 Next Steps

1. **Domain Setup**: Point your domain to server IP
2. **SSL Certificate**: Run `certbot` for HTTPS
3. **Backend Integration**: Configure `BACKEND_URL`
4. **Monitoring**: Set up alerts for service failures
5. **Backups**: Implement regular backups

## 📞 Support

- Check logs: `sudo journalctl -u evefrontier-club -f`
- Nginx errors: `/var/log/nginx/error.log`
- System resources: `free -h`, `top`, `df -h`
- GitHub Actions: Check workflow run details

## 📖 Additional Resources

- [Jaspr Documentation](https://docs.jaspr.site)
- [Systemd Manual](https://www.freedesktop.org/software/systemd/man/systemd.service.html)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [GitHub Actions Docs](https://docs.github.com/en/actions)

---

**Status**: ✅ Production Ready
**Target Environment**: Ubuntu/Oracle Linux, 1GB RAM, 1 CPU
**Last Updated**: 2026-03-26
