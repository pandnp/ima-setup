#!/bin/bash

VM=$1 # set VM=1 for virtual machine, set VM=0 for hardware

./install-pkgs.sh
./install-ima-evm-utils.sh
./install-evmctl.sh
./create-keys.sh $VM
./mount-iversion.sh
./mkinitramfs.sh
./grub-fix-mode.sh $VM
