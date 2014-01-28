#!/bin/bash

sed -i "s/evm=fix//g" /etc/default/grub
sed -i "s/ima_appraise=fix//g" /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

reboot
