#!/usr/bin/env bash

set -e
set -o pipefail

CERT_COUNTRY="US"
CERT_ORG="AccelByte"
CERT_ROOT_CN="AccelByte Test Root CA"
CERT_CA_DAYS=3650
CERT_DAYS=365

CERT_CA_KEY_FILE="root_CA.key"
CERT_CA_PEM_FILE="root_CA_cert.pem"

CERT_SV_KEY_FILE="server_cert.key"
CERT_SV_CSR_FILE="server_cert.csr"
CERT_SV_PEM_FILE="server_cert.pem"

CERT_CL_KEY_FILE="client_cert.key"
CERT_CL_CSR_FILE="client_cert.csr"
CERT_CL_PEM_FILE="client_cert.pem"

CERT_DIR=compose-config/certs
if [ $# -eq 1 ]; then
    CERT_DIR=$1
fi

echo -e "Certificate directory: $CERT_DIR\n"
mkdir -p "$CERT_DIR"

# openssl genrsa -out "$CERT_DIR/client_cert.key" 2048

echo -e -n "Create CA key..."
openssl genrsa -out "$CERT_DIR/$CERT_CA_KEY_FILE" 4096 2> /dev/null
echo -e "OK"

echo -e -n "Create CA certificate..."
CA_SUBJECT="/C=$CERT_COUNTRY/O=$CERT_ORG/CN=$CERT_ROOT_CN"
openssl req -x509 -new -nodes -sha256 -days "$CERT_CA_DAYS" \
    -key "$CERT_DIR/$CERT_CA_KEY_FILE" \
    -out "$CERT_DIR/$CERT_CA_PEM_FILE" \
    -subj "$CA_SUBJECT"
echo -e "OK"

echo -e -n "Create server key..."
openssl genrsa -out "$CERT_DIR/$CERT_SV_KEY_FILE" 2048 2> /dev/null
echo -e "OK"

echo -e -n "Create server certificate..."
SERVER_SUBJECT="/C=$CERT_COUNTRY/O=$CERT_ORG"
openssl req -new \
    -key "$CERT_DIR/$CERT_SV_KEY_FILE" \
    -out "$CERT_DIR/$CERT_SV_CSR_FILE" \
    -subj "$SERVER_SUBJECT"
openssl x509 -req -CAcreateserial -sha256 -days "$CERT_DAYS" \
    -in "$CERT_DIR/$CERT_SV_CSR_FILE" \
    -CA "$CERT_DIR/$CERT_CA_PEM_FILE" \
    -CAkey "$CERT_DIR/$CERT_CA_KEY_FILE" \
    -out "$CERT_DIR/$CERT_SV_PEM_FILE" \
    -extfile <(printf "authorityKeyIdentifier = keyid, issuer\nbasicConstraints = CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = DNS:host.docker.internal, DNS:localhost") \
    2> /dev/null
echo -e "OK"

echo -e -n "Validate server certificate... "
openssl verify -verbose -CAfile "$CERT_DIR/$CERT_CA_PEM_FILE" "$CERT_DIR/$CERT_SV_PEM_FILE"

echo -e -n "Create client key..."
openssl genrsa -out "$CERT_DIR/$CERT_CL_KEY_FILE" 2048 2> /dev/null
echo -e "OK"

echo -e -n "Create client certificate..."
CLIENT_SUBJECT="/C=$CERT_COUNTRY/O=$CERT_ORG"
openssl req -new \
    -key "$CERT_DIR/$CERT_CL_KEY_FILE" \
    -out "$CERT_DIR/$CERT_CL_CSR_FILE" \
    -subj "$CLIENT_SUBJECT"
openssl x509 -req -CAcreateserial -sha256 -days "$CERT_DAYS" \
    -in "$CERT_DIR/$CERT_CL_CSR_FILE" \
    -CA "$CERT_DIR/$CERT_CA_PEM_FILE" \
    -CAkey "$CERT_DIR/$CERT_CA_KEY_FILE" \
    -out "$CERT_DIR/$CERT_CL_PEM_FILE" \
    -extfile <(printf "authorityKeyIdentifier = keyid, issuer\nbasicConstraints = CA:FALSE\nkeyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment\nsubjectAltName = DNS:host.docker.internal, DNS:localhost") \
    2> /dev/null
echo -e "OK"

echo -e -n "Validate client certificate... "
openssl verify -verbose -CAfile "$CERT_DIR/$CERT_CA_PEM_FILE" "$CERT_DIR/$CERT_CL_PEM_FILE"

rm -rf "$CERT_DIR/$CERT_SV_CSR_FILE"
rm -rf "$CERT_DIR/$CERT_CL_CSR_FILE"

echo -e "Finished"