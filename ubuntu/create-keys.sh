#!/bin/bash

TPM=$1

# create keys
cd /usr/bin/labeling
./evm_create_keys.sh $TPM

if [ $1 -eq "tpm" ]; then
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="user"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
elif [ $1 -eq "notpm" ]; then
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="trusted"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
fi

if [ ! -e /etc/sysconfig ]; then
  mkdir /etc/sysconfig
fi
echo "$MASTERKEY" > /etc/sysconfig/masterkey
