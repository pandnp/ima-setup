#!/bin/bash

if [ $1 == 'tpm' ]; then # tpm mode
evmpath="evmkey=\/etc\/keys\/evm-trusted.blob"
elif [ $1 == "notpm" ]; then # no tpm mode
evmpath="evmkey=\/etc\/keys\/evm-user.blob"
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
grub2-mkconfig -o /boot/grub2/grub.cfg
