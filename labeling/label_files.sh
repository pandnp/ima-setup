#!/bin/bash
#
# Must be in 'fix' mode to label filesystem

cmdline=`cat /proc/cmdline`

found=1
bootoptions="ima_tcb ima_appraise_tcb evm=fix ima_appraise=fix"
for p in $bootoptions; do
   case "$cmdline" in 
     *$p*)
    ;;
    *)
    echo 'Missing boot command line option:' $p
    found=0
    ;;
   esac
done

if [ $found -eq 0 ]
then
   exit
fi

# For now, just sign executables. In the future, we'll want to sign as
# many files as possible.

date
dirlist="/root /usr/include /var /home "
for d in $dirlist; do 
   echo `date --rfc-3339=ns` 'subdir= '$d
   find $d -type f -uid 0 -exec sh -c "< '{}'" \;
done

dirlist="/bin /sbin /etc /usr/bin /usr/sbin /usr/libexec /usr/local /usr/lib64 /usr/lib /usr/share /opt/"
for d in $dirlist; do 
   echo `date --rfc-3339=ns` 'subdir= '$d 'using local'
   find $d -type f -uid 0 -exec ./sign_executable.sh '{}' /etc/keys/private/local_privkey.pem \;
done

dirlist="/boot"
for d in $dirlist; do 
   echo `date --rfc-3339=ns` 'subdir= '$d
   find $d -type f -exec sh -c "< '{}'" \;
done
date
