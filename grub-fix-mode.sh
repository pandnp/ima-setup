#!/bin/bash

if [ $1 == 1 ]; then
OPTIONS='ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix evmkey=\/etc\/keys\/evm-user.blob evmx509=\/etc\/keys\/local_x509.der'
else
OPTIONS='ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix evmkey=\/etc\/keys\/evm-trusted.blob evmx509=\/etc\/keys\/local_x509.der'
fi

grub2-mkconfig -o /boot/grub2/grub.cfg

sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 $OPTIONS\"/" /etc/default/grub

grub2-mkconfig -o /boot/grub2/grub.cfg

reboot
