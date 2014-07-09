#!/bin/bash

#install ima-evm-utils
git clone git://git.code.sf.net/p/linux-ima/ima-evm-utils
cd ima-evm-utils
./autogen.sh
./configure --prefix=/usr
make
make install
ln -s /usr/bin/evmctl /sbin
ldconfig
