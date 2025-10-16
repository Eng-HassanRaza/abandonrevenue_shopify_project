#!/bin/bash

echo "================================================"
echo "  Abandon Revenue - Setup Verification"
echo "================================================"
echo ""

PROJECT_DIR="/home/ubuntu/abandonrevenue_shopify_project"
ERRORS=0

check_file() {
    if [ -f "$1" ]; then
        echo "✅ $2"
    else
        echo "❌ $2 - MISSING"
        ((ERRORS++))
    fi
}

check_dir() {
    if [ -d "$1" ]; then
        echo "✅ $2"
    else
        echo "❌ $2 - MISSING"
        ((ERRORS++))
    fi
}

check_executable() {
    if [ -x "$1" ]; then
        echo "✅ $2"
    else
        echo "⚠️  $2 - Not executable (run: chmod +x $1)"
    fi
}

echo "Checking Configuration Files:"
echo "------------------------------"
check_file "$PROJECT_DIR/requirements.txt" "requirements.txt"
check_file "$PROJECT_DIR/gunicorn_config.py" "gunicorn_config.py"
check_file "$PROJECT_DIR/.env.example" ".env.example"
check_file "$PROJECT_DIR/systemd/gunicorn.service" "systemd/gunicorn.service"
check_file "$PROJECT_DIR/nginx/abandonrevenue.conf" "nginx/abandonrevenue.conf"
check_file "$PROJECT_DIR/abandon_revenue/settings.py" "Django settings.py"

echo ""
echo "Checking Scripts:"
echo "-----------------"
check_file "$PROJECT_DIR/setup.sh" "setup.sh"
check_executable "$PROJECT_DIR/setup.sh" "setup.sh is executable"
check_file "$PROJECT_DIR/restart_services.sh" "restart_services.sh"
check_executable "$PROJECT_DIR/restart_services.sh" "restart_services.sh is executable"
check_file "$PROJECT_DIR/backup.sh" "backup.sh"
check_executable "$PROJECT_DIR/backup.sh" "backup.sh is executable"

echo ""
echo "Checking Documentation:"
echo "-----------------------"
check_file "$PROJECT_DIR/README.md" "README.md"
check_file "$PROJECT_DIR/DEPLOYMENT.md" "DEPLOYMENT.md"
check_file "$PROJECT_DIR/QUICK_REFERENCE.md" "QUICK_REFERENCE.md"
check_file "$PROJECT_DIR/SETUP_SUMMARY.txt" "SETUP_SUMMARY.txt"

echo ""
echo "Checking Django Project:"
echo "------------------------"
check_file "$PROJECT_DIR/manage.py" "manage.py"
check_file "$PROJECT_DIR/abandon_revenue/wsgi.py" "wsgi.py"
check_dir "$PROJECT_DIR/waitlist" "waitlist app"

echo ""
echo "Environment Check:"
echo "------------------"
if [ -f "$PROJECT_DIR/.env" ]; then
    echo "✅ .env file exists"
    echo "⚠️  Please verify .env configuration"
else
    echo "⚠️  .env file not found (copy from .env.example)"
fi

if [ -d "$PROJECT_DIR/venv" ]; then
    echo "✅ Virtual environment exists"
else
    echo "❌ Virtual environment not found - Run: python3 -m venv venv"
    ((ERRORS++))
fi

echo ""
echo "================================================"
if [ $ERRORS -eq 0 ]; then
    echo "✅ All required files are present!"
    echo ""
    echo "Next steps:"
    echo "1. Copy .env.example to .env and configure"
    echo "2. Run ./setup.sh to deploy"
else
    echo "❌ Found $ERRORS missing files/directories"
    echo "Please ensure all files are in place before deployment"
fi
echo "================================================"

