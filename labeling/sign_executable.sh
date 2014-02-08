#!/bin/sh
# label "immutable" files or modules with EVM/IMA digital signatures
# label everything else with just hash/hmac

ALG='sha1'
PRIVKEY=/etc/keys/private/local.pem

if [ $# -eq 2 ]; then
   PRIVKEY="$2"
fi

file --brief "$1" | grep -e ELF -e script > /dev/null
if [ $? -eq 0 ]; then
       	evmctl ima_sign -u -x -k "$PRIVKEY" --imasig "$1"
else
       	sh -c "<\"$1\""
fi

