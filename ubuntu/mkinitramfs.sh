#!/bin/sh

# $1 = VM
if [ $1 -eq "1" ]; then
	cp notpm-hooks /usr/share/initramfs-tools/hooks/ima
	cp notpm-premount /usr/share/initramfs-tools/scripts/init-premount/ima
else
	cp tpm-hooks /usr/share/initramfs-tools/hooks/ima
	cp tpm-premount /usr/share/initramfs-tools/scripts/init-premount/ima
fi


cd /boot
mkinitramfs -k -o initrd.img-`uname -r` `uname -r`
#update-initramfs -u
