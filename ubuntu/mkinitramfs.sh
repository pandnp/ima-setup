#!/bin/bash

hooks='/etc/initramfs-tools/hooks/ima'
localtop='/etc/initramfs-tools/scripts/local-top/ima.sh'

# load keyring and enable evm in initramfs

# $1 = TPM
if [ "$1" == "tpm" ]; then
  kmk='/etc/keys/kmk-trusted.blob'
  evm='/etc/keys/evm-trusted.blob'
  load_kmk='keyctl add trusted kmk-trusted "load `cat /etc/keys/kmk-trusted.blob`" @u > /dev/null'
  load_evm='keyctl add encrypted evm-key "load `cat /etc/keys/evm-trusted.blob`" @u > /dev/null'
elif [ "$1" == "notpm" ]; then
  kmk='/etc/keys/kmk-user.blob'
  evm='/etc/keys/evm-user.blob'
  load_kmk='keyctl add user kmk-user "`cat /etc/keys/kmk-user.blob`" @u > /dev/null'
  load_evm='keyctl add encrypted evm-key "load `cat /etc/keys/evm-user.blob`" @u > /dev/null'
fi

ima_hooks='#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

# Begin real processing below this line
. /usr/share/initramfs-tools/hook-functions
copy_exec /sys/kernel/security/evm
copy_exec /usr/local/bin/evmctl /sbin
copy_exec /bin/keyctl /sbin
copy_exec /etc/keys/local_x509.der
copy_exec /etc/keys/private/local_priv.pem'

ima_hooks="$ima_hooks
copy_exec "$kmk"
copy_exec "$evm""

ima_premount='#!/bin/sh
PREREQ=""
prereqs()
{
     echo "$PREREQ"
}

case $1 in
prereqs)
     prereqs
     exit 0
     ;;
esac

ima_id=`/sbin/keyctl newring _ima @u`
evm_id=`/sbin/keyctl newring _evm @u`
for PUBKEY in /etc/keys/*.der; do
    evmctl import $PUBKEY $ima_id > /dev/null
    evmctl import $PUBKEY $evm_id > /dev/null
done'

ima_premount="$ima_premount
"$load_kmk"
"$load_evm"

#enable EVM
mount -n -t securityfs securityfs /sys/kernel/security
echo "1" > /sys/kernel/security/evm
sleep 3"

echo "$ima_hooks" > $hooks
echo "$ima_premount" > $localtop

chmod u+x $hooks
chmod u+x $localtop

cd /boot
mkinitramfs -k -o initrd.img-`uname -r` `uname -r`
