#!/bin/bash
#
# Create symmetric key used for the EVM HMAC

CONFIG=VM
if [ $# -eq 1 ]; then 
   CONFIG="${1}"
fi

# For HW: create and save the kernel master key (trusted type):
if [ ${CONFIG} == "TPM" ]; then
   modprobe trusted encrypted
   keyctl add trusted kmk-trusted "new 32" @u
   keyctl pipe `keyctl search @u trusted kmk-trusted` > /etc/keys/kmk-trusted.blob

#  Create the EVM encrypted key
   keyctl add encrypted evm-key "new trusted:kmk-trusted 32" @u
   keyctl pipe `keyctl search @u encrypted evm-key` > /etc/keys/evm-trusted.blob
fi

# For VM: create and save the kernel master key (user type):
if [ ${CONFIG} == "NOTPM" ]; then
   keyctl add user kmk-user "`dd if=/dev/urandom bs=1 count=32 2>/dev/null`" @u
   keyctl pipe `keyctl search @u user kmk-user` > /etc/keys/kmk-user.blob

#  Create the EVM encrypted key
   keyctl add encrypted evm-key "new user:kmk-user 32" @u
   keyctl pipe `keyctl search @u encrypted evm-key` > /etc/keys/evm-user.blob
fi
