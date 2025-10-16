# Abandon Revenue - Shopify Project

Django-based web application for Abandon Revenue, configured for production deployment with Gunicorn, Nginx, and SSL.

## 🚀 Quick Start

### Automated Setup

```bash
chmod +x setup.sh
./setup.sh
```

This will automatically:
- Install all system dependencies
- Set up Python virtual environment
- Configure Gunicorn and Nginx
- Install SSL certificate with Let's Encrypt
- Set up auto-renewal for SSL

### Manual Setup

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed manual setup instructions.

## 📁 Project Structure

```
abandonrevenue_shopify_project/
├── abandon_revenue/          # Django project settings
│   ├── settings.py          # Main settings (production-ready)
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
├── waitlist/                # Django app
├── nginx/                   # Nginx configuration
│   └── abandonrevenue.conf
├── systemd/                 # Systemd service files
│   └── gunicorn.service
├── logs/                    # Application logs
├── media/                   # User uploaded files
├── staticfiles/            # Collected static files
├── gunicorn_config.py      # Gunicorn configuration
├── requirements.txt        # Python dependencies
├── .env.example           # Environment variables template
├── setup.sh               # Automated setup script
├── restart_services.sh    # Restart Gunicorn & Nginx
├── backup.sh              # Backup script
├── DEPLOYMENT.md          # Detailed deployment guide
└── QUICK_REFERENCE.md     # Command quick reference
```

## 🛠 Common Commands

### Service Management
```bash
# Restart all services
./restart_services.sh

# Individual services
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

### Django Operations
```bash
source venv/bin/activate
python manage.py migrate
python manage.py createsuperuser
python manage.py collectstatic
```

### View Logs
```bash
tail -f logs/gunicorn-error.log
sudo tail -f /var/log/nginx/abandonrevenue_error.log
```

### Backup
```bash
./backup.sh
```

## 🔒 Security Features

- ✅ SSL/TLS encryption via Let's Encrypt
- ✅ Automatic SSL certificate renewal
- ✅ Security headers (HSTS, XSS Protection, etc.)
- ✅ HTTPS redirect
- ✅ Django security middleware
- ✅ Environment-based configuration

## 📚 Documentation

- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick command reference

## ⚙️ Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
nano .env
```

Required settings:
- `SECRET_KEY` - Django secret key (generate new one for production)
- `DEBUG` - Set to `False` for production
- `ALLOWED_HOSTS` - Your domain names
- `EMAIL_*` - Email configuration

### Domain Configuration

Update domain names in:
- `.env` - `ALLOWED_HOSTS`
- `nginx/abandonrevenue.conf` - `server_name`
- `setup.sh` - `DOMAIN` variable

## 🔄 Updating the Application

```bash
cd /home/ubuntu/abandonrevenue_shopify_project
source venv/bin/activate
git pull
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
./restart_services.sh
```

## 🆘 Troubleshooting

### 502 Bad Gateway
```bash
sudo systemctl status gunicorn
tail -f logs/gunicorn-error.log
sudo systemctl restart gunicorn
```

### SSL Issues
```bash
sudo certbot certificates
sudo certbot renew --dry-run
```

### Static Files Not Loading
```bash
python manage.py collectstatic --noinput
./restart_services.sh
```

## 📋 Requirements

- Ubuntu/Debian Linux
- Python 3.8+
- Nginx
- Domain name with DNS configured
- Ports 80 and 443 open

## 🔐 Production Checklist

Before going live:
- [ ] Set `DEBUG=False` in `.env`
- [ ] Generate strong `SECRET_KEY`
- [ ] Configure proper `ALLOWED_HOSTS`
- [ ] Set up email configuration
- [ ] Create Django superuser
- [ ] Test SSL certificate
- [ ] Verify auto-renewal works
- [ ] Configure firewall
- [ ] Set up regular backups
- [ ] Review security headers

## 📞 Support

For issues and questions, check:
1. Application logs: `logs/gunicorn-error.log`
2. Nginx logs: `/var/log/nginx/abandonrevenue_error.log`
3. Systemd logs: `sudo journalctl -u gunicorn`

## 📄 License

[Add your license information here]
