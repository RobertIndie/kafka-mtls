#!/bin/bash

# Extract certificates from JKS keystore for librdkafka client
# librdkafka uses OpenSSL which supports PEM or PKCS#12, but NOT JKS format
# This script creates both formats:
# 1. PKCS#12 (.p12) - single file with cert + key (recommended)
# 2. PEM format - separate .crt, .key, .ca files

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLIENT_CERT_DIR="$SCRIPT_DIR/../certCreation/secrets/client"
OUTPUT_DIR="$CLIENT_CERT_DIR"

KEYSTORE="$CLIENT_CERT_DIR/kafka.client1.keystore.jks"
TRUSTSTORE="$CLIENT_CERT_DIR/kafka.client1.truststore.jks"
PASSWORD="changeit"
ALIAS="lydtech-client1"

echo "Extracting certificates from JKS keystore for librdkafka..."
echo "Note: librdkafka doesn't support JKS format, so we convert to PKCS#12/PEM"
echo ""

# Create PKCS#12 format (single file with certificate + private key)
echo "Creating PKCS#12 format (client.p12)..."
keytool -importkeystore -srckeystore "$KEYSTORE" -srcstorepass "$PASSWORD" \
    -srcalias "$ALIAS" -destkeystore "$OUTPUT_DIR/client.p12" \
    -deststoretype PKCS12 -deststorepass "$PASSWORD" -noprompt

# Extract PEM format files (separate cert and key)
echo "Extracting PEM format files..."

# Extract client certificate
echo "  - Extracting client certificate (client.crt)..."
keytool -exportcert -alias "$ALIAS" -keystore "$KEYSTORE" \
    -storepass "$PASSWORD" -rfc -file "$OUTPUT_DIR/client.crt"

# Extract private key
echo "  - Extracting private key (client.key)..."
openssl pkcs12 -in "$OUTPUT_DIR/client.p12" -nodes -nocerts \
    -out "$OUTPUT_DIR/client.key" -passin pass:"$PASSWORD"

# Extract CA certificate from truststore
echo "  - Extracting CA certificate (ca.crt)..."
keytool -exportcert -alias CARoot -keystore "$TRUSTSTORE" \
    -storepass "$PASSWORD" -rfc -file "$OUTPUT_DIR/ca.crt"

echo ""
echo "Certificates extracted successfully:"
echo "  PKCS#12 format (recommended):"
echo "    - $OUTPUT_DIR/client.p12 (certificate + private key)"
echo "    - $OUTPUT_DIR/ca.crt (CA certificate)"
echo ""
echo "  PEM format (alternative):"
echo "    - $OUTPUT_DIR/client.crt (client certificate)"
echo "    - $OUTPUT_DIR/client.key (private key)"
echo "    - $OUTPUT_DIR/ca.crt (CA certificate)"

