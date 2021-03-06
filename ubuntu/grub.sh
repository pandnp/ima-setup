#!/bin/bash

# enable ima-appraisal and evm in grub

notpm="evmkey=\/etc\/keys\/evm-user.blob"
tpm="evmkey=\/etc\/keys\/evm-trusted.blob"

# $1 = tpm
if [ "$1" == "tpm" ]; then
evmpath=$tpm
elif [ "$1" == "notpm" ]; then
evmpath=$notpm
fi

# $2 = fix or enforce
if [ "$2" == "fix" ]; then
  options="ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix evmx509=\/etc\/keys\/local_x509.der $evmpath"
elif [ "$2" == "enforce" ]; then
  options="ima_tcb ima_appraise_tcb evmx509=\/etc\/keys\/local_x509.der $evmpath"
fi

remove=("ima_tcb" "ima_appraise_tcb" "evm=fix" "ima_appraise=fix" "evmx509=\/etc\/keys\/local_x509.der" "$notpm" "$tpm")

# clean up changes from previous runs
for i in "${remove[@]}"
do
  :
  sed -i "s/ $i//g" /etc/default/grub
  sed -i "s/$i//g" /etc/default/grub
done

# remove extra spaces
sed -i "s/  / /g" /etc/default/grub

# set new ima-appraisal options
sed -i "s/GRUB_CMDLINE_LINUX=\"\(.*\)\"/GRUB_CMDLINE_LINUX=\"\1 $options\"/" /etc/default/grub

# regenerate grub.cfg
update-grub2
