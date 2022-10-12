#!/bin/sh
# Entrypoint for idrive
echo "iDrive start.."
echo "checking for updates to iDrive perl scripts"
/work/IDriveForLinux/scripts/check_for_update.pl silent

# docker logs
tail -f /var/log/idrive.log