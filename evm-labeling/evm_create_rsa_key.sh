#!/bin/bash
#
# Create asymmetric key used to sign/verify immutable file signatures.

ALG="sha1"
PREFIX="local"
X509CONFIG="x509.genkey"
X509KEY_PEM="x509.pem"
X509KEY="x509.der"
PRIVKEY="privkey.pem"

show_help()
{
   echo "$0  < hash algorithm >  | [< key prefix >]"
   echo "default:"
   echo "  hash algorithm: sha1"
   echo " keyname prefix: local"
}

create_config_file()
{
cat > $X509CONFIG <<HEREDOC
[ req ]
default_bits = 1024
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = myexts

[ req_distinguished_name ]
O = ${NAME}
CN = pseudo signing key
emailAddress = slartibartfast@magrathea.h2g2

[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid:always,issuer:always
HEREDOC
}

if [ $# == 0 ]; then 
   show_help
   exit
fi

if [ $# -gt 0 ]; then 
   ALG=$1
fi

if [ $# -eq 2 ]; then 
   PREFIX="${2}_"
   NAME="${2}"
else
   PREFIX="${PREFIX}_"
   NAME="${PREFIX}"
fi

X509CONFIG="${PREFIX}${X509CONFIG}"
X509KEY="${PREFIX}${X509KEY}"
X509KEY_PEM="${PREFIX}${X509KEY_PEM}"
PRIVKEY="${PREFIX}${PRIVKEY}"

if [ ! -e $X509CONFIG ]; then
   create_config_file
fi
# FIX: *** The private key should be kept private. ***
openssl req -new -nodes -utf8 -$ALG -days 36500 -batch \
              -x509 -config ${X509CONFIG} \
              -out ${X509KEY_PEM} -keyout ${PRIVKEY}

openssl x509 -in ${X509KEY_PEM} -inform PEM -out ${X509KEY} -outform DER

if [ ! -e /etc/keys/private ]; then
#   sudo mkdir /etc/keys/private
   su -c "mkdir /etc/keys/private"
fi
# sudo not accessibly on rhel
#sudo cp ${PRIVKEY} /etc/keys/private/${PRIVKEY}
#sudo cp ${X509KEY} /etc/keys/${X509KEY}

echo "copying keys to /etc/keys, enter root password:"
set -x
su -c "cp ${PWD}/${PRIVKEY} /etc/keys/private/${PRIVKEY}"
su -c "cp ${PWD}/${X509KEY} /etc/keys/${X509KEY}"
set +x

# cleanup
rm ${PRIVKEY} ${X509KEY} ${X509CONFIG} ${X509KEY_PEM}
