#!/bin/bash

if [$1 == 1]; then # vm mode 
evmpath="evmkey=\/etc\/keys\/evm-user.blob"
else # hw mode
evmpath="evmkey=\/etc\/keys\/evm-trusted.blob"
fi

options="ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix evmx509=\/etc\/keys\/local_x509.der $evmpath"

# clean up changes from previous runs
for i in "${options[@]}"
do
  :
  sed -i "s/$i //g" /etc/default/grub
  sed -i "s/$i//g" /etc/default/grub
done

# set new ima-appraisal options
sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 $options\"/" /etc/default/grub

# regenerate grub.cfg
#grub2-mkconfig -o /boot/grub2/grub.cfg
update-grub2

#reboot
