#!/bin/sh

cp ima-init-premount /usr/share/initramfs-tools/scripts/init-premount/ima
cp ima-hooks /usr/share/initramfs-tools/hooks/ima

cd /boot
mkinitramfs -k -o initrd.img-`uname -r` `uname -r`
#update-initramfs -u
