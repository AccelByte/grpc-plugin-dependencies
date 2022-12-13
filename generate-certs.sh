#!/usr/bin/env bash

set -e
set -o pipefail

CERT_COUNTRY="US"
CERT_ORG="AccelByte"
CERT_ROOT_CN="AccelByte Test Root CA"
CERT_CA_DAYS=3650
CERT_DAYS=365

CERT_CA_KEY_FILE="root_ca.key"
CERT_CA_PEM_FILE="root_ca.pem"

CERT_SV_KEY_FILE="server.key"
CERT_SV_CSR_FILE="server.csr"
CERT_SV_PEM_FILE="server.pem"

CERT_CL_KEY_FILE="client.key"
CERT_CL_KEY_PK8_FILE="client_pkcs8.key"
CERT_CL_CSR_FILE="client.csr"
CERT_CL_PEM_FILE="client.pem"

CERT_DIR="certs"
if [ $# -eq 1 ]; then
    CERT_DIR=$1
fi

echo -e "Certificate directory: $CERT_DIR\n"
mkdir -p "$CERT_DIR"

# openssl genrsa -out "$CERT_DIR/client.key" 2048

echo -e -n "Create CA key ... "
openssl genrsa -out "$CERT_DIR/$CERT_CA_KEY_FILE" 4096 2> /dev/null
echo -e "OK"

echo -e -n "Create CA certificate ... "
CA_SUBJECT="/C=$CERT_COUNTRY/O=$CERT_ORG/CN=$CERT_ROOT_CN"
openssl req -x509 -new -nodes -sha256 -days "$CERT_CA_DAYS" \
    -key "$CERT_DIR/$CERT_CA_KEY_FILE" \
    -out "$CERT_DIR/$CERT_CA_PEM_FILE" \
    -subj "$CA_SUBJECT"
echo -e "OK"

echo -e -n "Create server key ... "
openssl genrsa -out "$CERT_DIR/$CERT_SV_KEY_FILE" 2048 2> /dev/null
echo -e "OK"

echo -e -n "Create server certificate ... "
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

echo -e -n "Validate server certificate ... "
openssl verify -verbose -CAfile "$CERT_DIR/$CERT_CA_PEM_FILE" "$CERT_DIR/$CERT_SV_PEM_FILE"

echo -e -n "Create client key ... "
openssl genrsa -out "$CERT_DIR/$CERT_CL_KEY_FILE" 2048 2> /dev/null
echo -e "OK"

echo -e -n "Convert client key to PKCS8 format ... "
openssl pkcs8 -topk8 -nocrypt -in "$CERT_DIR/$CERT_CL_KEY_FILE" -out "$CERT_DIR/$CERT_CL_KEY_PK8_FILE"
echo -e "OK"

echo -e -n "Create client certificate ... "
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

echo -e -n "Validate client certificate ... "
openssl verify -verbose -CAfile "$CERT_DIR/$CERT_CA_PEM_FILE" "$CERT_DIR/$CERT_CL_PEM_FILE"

rm -rf "$CERT_DIR/$CERT_SV_CSR_FILE"
rm -rf "$CERT_DIR/$CERT_CL_CSR_FILE"

echo -e "Fixing permissions for Envoy proxy container ... "
chmod -v 644 $CERT_DIR/*
echo -e "OK"