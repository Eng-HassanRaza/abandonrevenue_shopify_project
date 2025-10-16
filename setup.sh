#!/bin/bash

set -e

echo "================================================"
echo "Abandon Revenue Django Project Setup Script"
echo "================================================"
echo ""

PROJECT_DIR="/home/ubuntu/abandonrevenue_shopify_project"
DOMAIN="abandonrevenue.com"
EMAIL="admin@abandonrevenue.com"

echo "Step 1: Update system packages"
sudo apt-get update
sudo apt-get upgrade -y

echo ""
echo "Step 2: Install system dependencies"
sudo apt-get install -y python3-pip python3-venv python3-dev nginx certbot python3-certbot-nginx postgresql postgresql-contrib libpq-dev build-essential

echo ""
echo "Step 3: Create project directories"
cd $PROJECT_DIR
mkdir -p logs media staticfiles

echo ""
echo "Step 4: Create and activate virtual environment"
python3 -m venv venv
source venv/bin/activate

echo ""
echo "Step 5: Install Python dependencies"
pip install --upgrade pip
pip install -r requirements.txt

echo ""
echo "Step 6: Set up environment file"
if [ ! -f .env ]; then
    echo "Creating .env file from template..."
    cp .env.example .env
    echo ""
    echo "⚠️  IMPORTANT: Please edit .env file with your actual configuration:"
    echo "   - SECRET_KEY: Generate a new Django secret key"
    echo "   - DEBUG: Set to False for production"
    echo "   - EMAIL settings: Configure your email provider"
    echo ""
    read -p "Press Enter to continue after you've edited .env file..."
fi

echo ""
echo "Step 7: Run Django migrations"
python manage.py makemigrations
python manage.py migrate

echo ""
echo "Step 8: Collect static files"
python manage.py collectstatic --noinput

echo ""
echo "Step 9: Create Django superuser (optional)"
read -p "Do you want to create a Django superuser? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    python manage.py createsuperuser
fi

echo ""
echo "Step 10: Set correct permissions"
sudo chown -R ubuntu:www-data $PROJECT_DIR
sudo chmod -R 755 $PROJECT_DIR
sudo chmod -R 775 $PROJECT_DIR/logs
sudo chmod -R 775 $PROJECT_DIR/media

echo ""
echo "Step 11: Install Gunicorn systemd service"
sudo cp $PROJECT_DIR/systemd/gunicorn.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gunicorn
sudo systemctl start gunicorn
echo "Gunicorn service status:"
sudo systemctl status gunicorn --no-pager

echo ""
echo "Step 12: Configure Nginx"
sudo cp $PROJECT_DIR/nginx/abandonrevenue.conf /etc/nginx/sites-available/abandonrevenue
sudo ln -sf /etc/nginx/sites-available/abandonrevenue /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

echo "Testing Nginx configuration..."
sudo nginx -t

echo ""
echo "Step 13: Create directory for certbot challenges"
sudo mkdir -p /var/www/certbot

echo ""
echo "Step 14: Restart Nginx"
sudo systemctl restart nginx
sudo systemctl enable nginx

echo ""
echo "Step 15: Install SSL certificate with Let's Encrypt"
read -p "Enter your email address for Let's Encrypt notifications: " LE_EMAIL
read -p "Enter your domain name (e.g., abandonrevenue.com): " LE_DOMAIN

sudo certbot certonly --nginx \
    -d $LE_DOMAIN \
    -d www.$LE_DOMAIN \
    --non-interactive \
    --agree-tos \
    --email $LE_EMAIL \
    --redirect

echo ""
echo "Step 16: Test SSL certificate auto-renewal"
sudo certbot renew --dry-run

echo ""
echo "Step 17: Set up automatic SSL renewal"
echo "Setting up cron job for certificate renewal..."
(sudo crontab -l 2>/dev/null; echo "0 0,12 * * * certbot renew --quiet --post-hook 'systemctl reload nginx'") | sudo crontab -

echo ""
echo "Step 18: Final restart of services"
sudo systemctl restart gunicorn
sudo systemctl restart nginx

echo ""
echo "================================================"
echo "✅ Setup Complete!"
echo "================================================"
echo ""
echo "Your Django application is now running with:"
echo "  - Gunicorn WSGI server"
echo "  - Nginx reverse proxy"
echo "  - SSL certificate from Let's Encrypt"
echo "  - Auto-renewal configured"
echo ""
echo "Access your site at:"
echo "  https://$DOMAIN"
echo "  https://www.$DOMAIN"
echo ""
echo "Useful commands:"
echo "  - Check Gunicorn status: sudo systemctl status gunicorn"
echo "  - Check Nginx status: sudo systemctl status nginx"
echo "  - View Gunicorn logs: tail -f $PROJECT_DIR/logs/gunicorn-error.log"
echo "  - View Nginx logs: sudo tail -f /var/log/nginx/abandonrevenue_error.log"
echo "  - Restart Gunicorn: sudo systemctl restart gunicorn"
echo "  - Restart Nginx: sudo systemctl restart nginx"
echo "  - Renew SSL manually: sudo certbot renew"
echo ""
echo "================================================"

