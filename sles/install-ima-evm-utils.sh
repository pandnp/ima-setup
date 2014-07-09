#!/bin/bash

#install ima-evm-utils
git clone git://git.code.sf.net/p/linux-ima/ima-evm-utils
cd ima-evm-utils
./autogen.sh
./configure
make
make install
ln -s /usr/local/bin/evmctl /sbin
ldconfig

