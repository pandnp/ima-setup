#! /bin/sh

ima_id=`keyctl newring _ima @u`
evm_id=`keyctl newring _evm @u`

evmctl -x import /etc/keys/local_x509.der $ima_id > /dev/null
evmctl -x import /etc/keys/local_x509.der $evm_id > /dev/null
keyctl add user kmk-user /etc/keys/kmk-user.blob @u > /dev/null
keyctl add encrypted evm-key "new user:kmk-user 32" @u
keyctl pipe `keyctl search @u encrypted evm-key` > /etc/keys/evm-user.blob

echo 1 > /sys/kernel/security/evm
