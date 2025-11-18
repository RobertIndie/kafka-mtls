#!/bin/bash

# Create CA private key with password
openssl genrsa -aes256 -out ca.key -passout pass:changeit 2048

# Create CA certificate
openssl req -new -x509 -key ca.key -out ca.crt -days 365 \
   -subj '/CN=ca.kafka.example.com/OU=TEST/O=LYDTECH/L=London/C=UK' \
   -passin pass:changeit
