#!/bin/bash

PROJECT_DIR="/home/ubuntu/abandonrevenue_shopify_project"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

mkdir -p $BACKUP_DIR

echo "Creating backup at $TIMESTAMP..."

echo "Backing up database..."
cp $PROJECT_DIR/db.sqlite3 $BACKUP_DIR/db_$TIMESTAMP.sqlite3

echo "Backing up media files..."
tar -czf $BACKUP_DIR/media_$TIMESTAMP.tar.gz $PROJECT_DIR/media/

echo "Backing up .env file..."
cp $PROJECT_DIR/.env $BACKUP_DIR/env_$TIMESTAMP

echo ""
echo "Backup complete! Files saved to:"
echo "  - $BACKUP_DIR/db_$TIMESTAMP.sqlite3"
echo "  - $BACKUP_DIR/media_$TIMESTAMP.tar.gz"
echo "  - $BACKUP_DIR/env_$TIMESTAMP"

echo ""
echo "Cleaning up old backups (keeping last 10)..."
cd $BACKUP_DIR
ls -t db_*.sqlite3 | tail -n +11 | xargs -r rm
ls -t media_*.tar.gz | tail -n +11 | xargs -r rm
ls -t env_* | tail -n +11 | xargs -r rm

echo "✅ Backup complete!"

