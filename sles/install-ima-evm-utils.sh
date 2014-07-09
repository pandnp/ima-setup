#!/bin/bash

#install ima-evm-utils
git clone git://git.code.sf.net/p/linux-ima/ima-evm-utils
cd ima-evm-utils
./autogen.sh
./configure --prefix=/usr
make
make install
ln -s /usr/bin/evmctl /sbin
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib
export LD_LIBRARY_PATH
ldconfig

