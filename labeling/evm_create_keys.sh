#!/bin/bash
#
# Create symmetric and asymmetric keys for the integrity subsystem.
# The symmetric key is used to calculate the EVM HMAC.  The asymmetric
# key is used to sign/verify immutable file signatures.

# Create symmetric key used for the EVM HMAC
PWD=`pwd`
TPM=$1

su -c 'mkdir -p /etc/keys'
if [ $TPM -eq "1" ]; then
  su - -c "$PWD/evm_create_symkey.sh TPM"
else
  su - -c "$PWD/evm_create_symkey.sh NOTPM"
fi

# Create local asymmetric key pair
$PWD/evm_create_rsa_key.sh sha256 local
