#!/bin/bash
#
# Create asymmetric key used to sign/verify immutable file signatures.

ALG="sha1"
PREFIX="local"
X509CONFIG="x509.genkey"
X509KEY="x509.pem"
X509KEYREQ="sign.req"
X509KEYSIGNED_PEM="signed.pem"
X509KEYSIGNED="signed.der"
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
X509KEYREQ="${PREFIX}${X509KEYREQ}"
X509KEYSIGNED_PEM="${PREFIX}${X509KEYSIGNED_PEM}"
X509KEYSIGNED="${PREFIX}${X509KEYSIGNED}"
PRIVKEY="${PREFIX}${PRIVKEY}"

if [ ! -e $X509CONFIG ]; then
   create_config_file
fi
# FIX: *** The private key should be kept private. ***
openssl req -new -nodes -utf8 -$ALG -days 36500 -batch \
              -x509 -config ${X509CONFIG} \
              -out ${X509KEY} -keyout ${PRIVKEY}

openssl x509 -x509toreq -in ${X509KEY} -out ${X509KEYREQ} -signkey ${PRIVKEY}

cd demoCA
openssl ca -config ./openssl.cnf -in ../${X509KEYREQ} -out ../${X509KEYSIGNED_PEM}

openssl x509 -in ../${X509KEYSIGNED_PEM} -inform PEM -out ../${X509KEYSIGNED} -outform DER
# cleanup
cd ..
rm ${X509KEYSIGNED_PEM} ${X509KEYREQ} ${X509CONFIG}

if [ ! -e /etc/keys/private ]; then
   sudo mkdir /etc/keys/private
fi
sudo cp ${PRIVKEY} /etc/keys/private/${PRIVKEY}
sudo cp ${X509KEYSIGNED} /etc/keys/${X509KEYSIGNED}

rm ${PRIVKEY} ${X509KEYSIGNED}

# Need to load the cacert.x509 on the system 'trusted' keyring
# su - -c "$PWD/evm_load_rsakey.sh ${X509KEYSIGNED}"
