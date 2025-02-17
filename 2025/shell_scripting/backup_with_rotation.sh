#!/bin/bash

<<info
This script performs periodic backups of a specified directory.
It compresses the backup into a ZIP file and keeps only the last 3 backups.

Usage:
    ./backup.sh <source_directory> <destination_directory>
info

src=$1
dest=$2

# generate timestamp for backup filename
timestamp=$(date '+%Y-%m-%d-%H-%M')

# create backup archive in ZIP format
zip -r "$dest/backup-$timestamp.zip" $src > /dev/null

echo "backup completed"

# Implement backup rotation - keeping only last 3 backups

backup-count=$(ls -t "$dest"/backup-*.zip 2>/dev/null | wc -l)
if [ "$backup_count" -gt 3 ]; then
    ls -t "$dest"/backup-*.zip | tail -n +4 | xargs rm -f
    echo "Oldest backups removed. Keeping only the last 3."
fi