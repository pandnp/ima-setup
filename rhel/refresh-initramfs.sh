#!/bin/bash

# Backup the existing initramfs, and create a new one based on the additional dracut patches
dracut -H -f /boot/initramfs-`uname -r`.img `uname -r` -M
