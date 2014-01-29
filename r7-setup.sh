#!/bin/bash

VM=1 # set VM=1 for virtual machine, set VM=0 for hardware

./install-ima-evm-utils.sh
./install-dracut-patches.sh
./install-evmctl.sh
./create-keys.sh $VM
./mount-iversion.sh
./refresh-initramfs.sh
./grub-fix-mode.sh $VM
