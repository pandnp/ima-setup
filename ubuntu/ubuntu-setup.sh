#!/bin/bash

TPM=$1

./install-pkgs.sh
./install-ima-evm-utils.sh
./install-labeling.sh
./create-keys.sh $TPM
./mount-iversion.sh
./mkinitramfs.sh $TPM
./grub.sh $TPM fix
