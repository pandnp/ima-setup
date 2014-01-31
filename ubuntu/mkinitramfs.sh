#!/bin/sh

cp ima-init-premount /usr/share/initramfs-tools/scripts/init-premount
cp ima-hooks /usr/share/initramfs-tools/hooks

#cd /boot
mkinitramfs -k -o initrd.img-`uname -r` `uname -r`
#update-initramfs -u
