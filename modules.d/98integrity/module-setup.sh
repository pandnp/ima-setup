#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    return 0 
}

depends() {
#   echo masterkey securityfs selinux
    echo masterkey securityfs 
    return 0
}

install() {
    dracut_install evmctl
    inst_hook pre-pivot 61 "$moddir/evm-enable.sh"
    inst_hook pre-pivot 62 "$moddir/ima-policy-load.sh"
}
