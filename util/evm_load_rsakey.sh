#!/bin/bash
#
X509KEY="x509_evm.der"

if [ $# == 1 ]; then
   echo "key: $1"
   X509KEY="$1"
fi

# load public key on _ima keyring
IMA_ID=`keyctl search @u keyring _ima`
if [ $? == 1 ]; then
   IMA_ID=`keyctl newring _ima @u`
fi
evmctl import /etc/keys/$X509KEY ${IMA_ID}


# load public key on _evm keyring
EVM_ID=`keyctl search @u keyring _evm`
if [ $? == 1 ]; then
   EVM_ID=`keyctl newring _evm @u`
fi
evmctl import /etc/keys/$X509KEY ${EVM_ID}
