#!/bin/bash

# create keys
cd /usr/bin/labeling
# edit evm_create_keys.sh, changing NOTPM to TPM, if you have a TPM.

if [ $1 -eq "1" ]; then
	sed -i 's/ TPM/ NOTPM/g' evm_create_keys.sh
else
	sed -i 's/ NOTPM/ TPM/g' evm_create_keys.sh
fi

./evm_create_keys.sh

if [ $1 -eq "1" ]; then
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="user"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
else
MASTERKEY='MULTIKERNELMODE="NO"
MASTERKEYTYPE="trusted"
MASTERKEY="/etc/keys/kmk-${MASTERKEYTYPE}.blob"'
fi

if [ ! -e /etc/sysconfig ]; then
  mkdir /etc/sysconfig
fi
echo "$MASTERKEY" > /etc/sysconfig/masterkey
