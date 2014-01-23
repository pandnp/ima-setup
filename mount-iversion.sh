#!/bin/bash

# mount the filesystems with iversion, edit /etc/fstab
sed -i 's/defaults/defaults,iversion/g' /etc/fstab
