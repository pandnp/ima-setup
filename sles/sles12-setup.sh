#!/bin/bash

TPM=$1 # set TPM=tpm for hardware, set TPM=notpm for virtual machine

./install-pkgs.sh
./install-ima-evm-utils.sh
./install-dracut-patches.sh
./create-keys.sh $TPM
./mount-iversion.sh
./refresh-initramfs.sh
./grub-fix-mode.sh $TPM
