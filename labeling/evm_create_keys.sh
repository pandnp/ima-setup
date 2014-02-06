#!/bin/bash
#
# Create symmetric and asymmetric keys for the integrity subsystem.
# The symmetric key is used to calculate the EVM HMAC.  The asymmetric
# key is used to sign/verify immutable file signatures.

# Create symmetric key used for the EVM HMAC
PWD=`pwd`

su -c 'mkdir -p /etc/keys'
su - -c "$PWD/evm_create_symkey.sh TPM"

# Create local asymmetric key pair
$PWD/evm_create_rsa_key.sh sha256 local
