# Quick Reference Guide

## Initial Setup

```bash
cd /home/ubuntu/abandonrevenue_shopify_project
chmod +x setup.sh
./setup.sh
```

## Common Commands

### Restart Services
```bash
./restart_services.sh
```

### Backup Database & Media
```bash
./backup.sh
```

### View Logs
```bash
# Gunicorn logs
tail -f logs/gunicorn-error.log
tail -f logs/gunicorn-access.log

# Nginx logs
sudo tail -f /var/log/nginx/abandonrevenue_error.log
sudo tail -f /var/log/nginx/abandonrevenue_access.log

# Systemd logs
sudo journalctl -u gunicorn -f
sudo journalctl -u nginx -f
```

### Service Management
```bash
# Gunicorn
sudo systemctl start gunicorn
sudo systemctl stop gunicorn
sudo systemctl restart gunicorn
sudo systemctl status gunicorn

# Nginx
sudo systemctl start nginx
sudo systemctl stop nginx
sudo systemctl restart nginx
sudo systemctl status nginx
```

### Django Management
```bash
source venv/bin/activate

# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Collect static files
python manage.py collectstatic

# Django shell
python manage.py shell

# Check deployment
python manage.py check --deploy
```

### Update Application
```bash
cd /home/ubuntu/abandonrevenue_shopify_project
source venv/bin/activate
git pull
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
./restart_services.sh
```

### SSL Certificate
```bash
# Renew manually
sudo certbot renew

# Test renewal
sudo certbot renew --dry-run

# List certificates
sudo certbot certificates
```

### File Permissions
```bash
sudo chown -R ubuntu:www-data /home/ubuntu/abandonrevenue_shopify_project
sudo chmod -R 755 /home/ubuntu/abandonrevenue_shopify_project
sudo chmod -R 775 /home/ubuntu/abandonrevenue_shopify_project/logs
sudo chmod -R 775 /home/ubuntu/abandonrevenue_shopify_project/media
```

### Environment Configuration
```bash
# Edit environment variables
nano .env

# After editing .env, restart Gunicorn
sudo systemctl restart gunicorn
```

## Troubleshooting

### 502 Bad Gateway
1. Check Gunicorn is running: `sudo systemctl status gunicorn`
2. Check logs: `tail -f logs/gunicorn-error.log`
3. Restart: `sudo systemctl restart gunicorn`

### Static Files Not Loading
```bash
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn
sudo systemctl restart nginx
```

### Database Issues
```bash
# Check migrations
python manage.py showmigrations

# Apply migrations
python manage.py migrate

# Reset database (⚠️ WARNING: Deletes all data)
rm db.sqlite3
python manage.py migrate
python manage.py createsuperuser
```

## Important Files

- Environment: `.env`
- Django settings: `abandon_revenue/settings.py`
- Gunicorn config: `gunicorn_config.py`
- Systemd service: `/etc/systemd/system/gunicorn.service`
- Nginx config: `/etc/nginx/sites-available/abandonrevenue`
- SSL certs: `/etc/letsencrypt/live/abandonrevenue.com/`

## Security Checklist

- [ ] `DEBUG=False` in `.env`
- [ ] Strong `SECRET_KEY` generated
- [ ] Firewall enabled (ports 22, 80, 443)
- [ ] Regular backups scheduled
- [ ] SSL certificate auto-renewal working
- [ ] Regular system updates
- [ ] Strong passwords for Django admin

