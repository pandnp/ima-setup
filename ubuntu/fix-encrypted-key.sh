#!/bin/sh

keyctl add encrypted evm-key "new user:kmk-user 32" @u
keyctl pipe `keyctl search @u encrypted evm-key` > /etc/keys/evm-user.blob
keyctl unlink `keyctl search @u encrypted evm-key`
keyctl add encrypted evm-key "load `cat /etc/keys/evm-user.blob`" @u
update-initramfs -u
