#!/bin/bash

TPM=$1 # tpm / notpm

./install-pkgs.sh
./install-ima-evm-utils.sh
./install-evm-labeling.sh
./create-keys.sh $TPM
./mount-iversion.sh
./mkinitramfs.sh $TPM
./grub.sh $TPM fix
