# Deployment Guide - Abandon Revenue Django Project

## Prerequisites

- Ubuntu/Debian Linux server
- Root or sudo access
- Domain name pointing to your server IP
- Port 80 and 443 open in firewall

## Quick Setup

Run the automated setup script:

```bash
cd /home/ubuntu/abandonrevenue_shopify_project
chmod +x setup.sh
./setup.sh
```

The script will guide you through the entire setup process.

## Manual Setup

### 1. Install System Dependencies

```bash
sudo apt-get update
sudo apt-get install -y python3-pip python3-venv python3-dev nginx certbot python3-certbot-nginx
```

### 2. Set Up Python Environment

```bash
cd /home/ubuntu/abandonrevenue_shopify_project
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 3. Configure Environment Variables

```bash
cp .env.example .env
nano .env
```

Update the following in `.env`:
- `SECRET_KEY`: Generate new Django secret key
- `DEBUG=False`
- `ALLOWED_HOSTS`: Your domain names
- Email configuration

### 4. Run Django Setup

```bash
python manage.py migrate
python manage.py collectstatic --noinput
python manage.py createsuperuser
```

### 5. Configure Gunicorn Service

```bash
sudo cp systemd/gunicorn.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn
```

### 6. Configure Nginx

```bash
sudo cp nginx/abandonrevenue.conf /etc/nginx/sites-available/abandonrevenue
sudo ln -s /etc/nginx/sites-available/abandonrevenue /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl restart nginx
```

### 7. Install SSL Certificate

```bash
sudo certbot --nginx -d abandonrevenue.com -d www.abandonrevenue.com
```

### 8. Set Up SSL Auto-Renewal

```bash
sudo certbot renew --dry-run
(sudo crontab -l; echo "0 0,12 * * * certbot renew --quiet --post-hook 'systemctl reload nginx'") | sudo crontab -
```

## Service Management

### Gunicorn

- Start: `sudo systemctl start gunicorn`
- Stop: `sudo systemctl stop gunicorn`
- Restart: `sudo systemctl restart gunicorn`
- Status: `sudo systemctl status gunicorn`
- Logs: `tail -f /home/ubuntu/abandonrevenue_shopify_project/logs/gunicorn-error.log`

### Nginx

- Start: `sudo systemctl start nginx`
- Stop: `sudo systemctl stop nginx`
- Restart: `sudo systemctl restart nginx`
- Status: `sudo systemctl status nginx`
- Test config: `sudo nginx -t`
- Logs: `sudo tail -f /var/log/nginx/abandonrevenue_error.log`

## Updating the Application

```bash
cd /home/ubuntu/abandonrevenue_shopify_project
source venv/bin/activate
git pull
pip install -r requirements.txt
python manage.py migrate
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn
```

## SSL Certificate Renewal

Certificates auto-renew via cron job. Manual renewal:

```bash
sudo certbot renew
sudo systemctl reload nginx
```

## Troubleshooting

### Gunicorn won't start

Check logs:
```bash
sudo journalctl -u gunicorn -n 50 --no-pager
tail -f /home/ubuntu/abandonrevenue_shopify_project/logs/gunicorn-error.log
```

### Nginx 502 Bad Gateway

- Check if Gunicorn is running: `sudo systemctl status gunicorn`
- Check Gunicorn logs
- Verify socket/port configuration

### SSL Issues

- Verify domain DNS points to server
- Check certbot logs: `sudo tail -f /var/log/letsencrypt/letsencrypt.log`
- Ensure ports 80 and 443 are open

### Static files not loading

```bash
python manage.py collectstatic --noinput
sudo systemctl restart gunicorn
```

## Security Notes

1. Keep `DEBUG=False` in production
2. Use strong `SECRET_KEY`
3. Regular system updates: `sudo apt-get update && sudo apt-get upgrade`
4. Monitor logs regularly
5. Set up firewall (ufw):
   ```bash
   sudo ufw allow 22
   sudo ufw allow 80
   sudo ufw allow 443
   sudo ufw enable
   ```

## Configuration Files

- Gunicorn config: `gunicorn_config.py`
- Systemd service: `systemd/gunicorn.service`
- Nginx config: `nginx/abandonrevenue.conf`
- Environment: `.env`
- Django settings: `abandon_revenue/settings.py`

