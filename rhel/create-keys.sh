#!/bin/bash

cd ../util
if [ $1 == tpm ]; then
./evm_create_keys.sh tpm
elif [ $1 == notpm ]; then
./evm_create_keys.sh notpm
fi

if [ $1 == tpm ]; then
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="trusted"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
elif [ $1 == notpm ]; then
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="user"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
fi

echo "$MASTERKEY" > /etc/sysconfig/masterkey
