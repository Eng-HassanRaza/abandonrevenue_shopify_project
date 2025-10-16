#!/bin/bash

echo "Restarting Abandon Revenue services..."
echo ""

echo "1. Collecting static files..."
source /home/ubuntu/abandonrevenue_shopify_project/venv/bin/activate
cd /home/ubuntu/abandonrevenue_shopify_project
python manage.py collectstatic --noinput

echo ""
echo "2. Restarting Gunicorn..."
sudo systemctl restart gunicorn
sleep 2

echo ""
echo "3. Restarting Nginx..."
sudo systemctl restart nginx
sleep 2

echo ""
echo "4. Checking service status..."
echo ""
echo "Gunicorn status:"
sudo systemctl status gunicorn --no-pager | head -n 10

echo ""
echo "Nginx status:"
sudo systemctl status nginx --no-pager | head -n 10

echo ""
echo "✅ Services restarted successfully!"

