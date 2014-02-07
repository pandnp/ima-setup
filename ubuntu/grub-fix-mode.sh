#!/bin/bash

vm="evmkey=\/etc\/keys\/evm-user.blob"
tpm="evmkey=\/etc\/keys\/evm-trusted.blob"

if [ $1 == "1" ]; then # vm mode 
evmpath=$vm
else # tpm mode
evmpath=$tpm
fi

options="ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix evmx509=\/etc\/keys\/local_x509.der $evmpath"

# clean up changes from previous runs
for i in "${options[@]}"
do
  :
  sed -i "s/ $i//g" /etc/default/grub
  sed -i "s/$i//g" /etc/default/grub
done

# remove vm/tpm key
sed -i "s/ $vm//g" /etc/default/grub
sed -i "s/ $tpm//g" /etc/default/grub
sed -i "s/$vm//g" /etc/default/grub
sed -i "s/$tpm//g" /etc/default/grub

# remove extra spaces
sed -i "s/  / /g" /etc/default/grub

# set new ima-appraisal options
sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 $options\"/" /etc/default/grub

# regenerate grub.cfg
update-grub2
#grub-mkconfig -o /boot/grub/grub.cfg
