#!/usr/bin/bash
set -x
clear


echo "Checking known disks and devices..." 
sleep 2
lsblk --output NAME,SIZE,TYPE,FSTYPE,LABEL,FSSIZE,FSUSED,FSAVAIL,FSUSE%,PATH,MOUNTPOINTS;
echo "Checking for any aditional usb devices"
sleep 2
lsusb
echo "Generating list of all filesystems and mountpoints..."
sleep 2
mount | /usr/bin/bat -p -P -l perl
echo "Checking system memory..."
sleep 2
free
echo "Checking Network routing and online availabilty..."
routel
ip link show | /usr/bin/bat -p -P -l java || echo "FAILED"
set +x
