# Kafka mTLS Example Project

A complete example demonstrating how to set up and use Apache Kafka with mutual TLS (mTLS) authentication. This project includes certificate generation, broker configuration, ACL setup, and client examples using both CLI tools and Python.

> **Note:** This repository is forked from [lydtechconsulting/kafka-mutual-tls](https://github.com/lydtechconsulting/kafka-mutual-tls)

## Overview

This project demonstrates:
- Certificate Authority (CA) and certificate generation for Kafka mTLS
- Kafka broker configuration with SSL/mTLS authentication
- Access Control List (ACL) setup for secure topic access
- Client connections using both Kafka CLI tools and Python (librdkafka)

## Prerequisites

- Docker and Docker Compose
- Bash shell
- Python 3.x (for Python client example)
- OpenSSL (for certificate generation)

## Quick Start

### 1. Generate Certificates

Generate all required certificates (CA, server, and client):

```sh
./certCreation/generate-all-certs.sh
```

This script creates:
- CA certificate and key
- Server keystore and truststore (JKS format)
- Client keystore and truststore (JKS format)
- All certificates are stored in `certCreation/secrets/`

### 2. Start Kafka Broker

Start the Kafka broker with mTLS configuration:

```sh
docker compose up -d
```

The broker will be available at `localhost:29092` with SSL/mTLS enabled.

### 3. Configure Kafka ACLs

Set up Access Control Lists to grant permissions to the client:

```sh
./scripts/acl.sh
```

This grants the client certificate:
- Read, Write, and Create operations on `my-topic`
- Read operations on all consumer groups

## Usage

### Kafka CLI Commands

The project includes convenient scripts for common Kafka operations:

1. **List topics:**
   ```sh
   ./scripts/list-topics.sh
   ```

2. **Consume messages:**
   ```sh
   ./scripts/consume.sh
   ```

3. **Produce messages:**
   ```sh
   ./scripts/produce.sh
   ```

### Python Client

The Python client uses `librdkafka` (via `confluent-kafka`), which requires certificates in PEM format. Extract PEM certificates from JKS keystores:

```sh
./scripts/extract-pem-from-jks.sh
```

This generates:
- `certCreation/secrets/client/ca.crt`
- `certCreation/secrets/client/client.crt`
- `certCreation/secrets/client/client.key`

Then run the Python producer:

```sh
cd python_client
pip install -r requirements.txt
python producer.py
```

The Python producer will:
- Connect to Kafka using mTLS authentication
- Allow interactive message sending
- Display delivery confirmations

## Project Structure

```
kafka-mtls/
├── certCreation/          # Certificate generation scripts and secrets
│   ├── secrets/
│   │   ├── server/        # Server certificates (keystore, truststore)
│   │   └── client/        # Client certificates (keystore, truststore, PEM)
│   └── *.sh              # Certificate generation scripts
├── scripts/              # Kafka CLI utility scripts
├── python_client/        # Python producer example
└── docker-compose.yml    # Kafka broker configuration
```

## Configuration Details

- **Broker Port:** `29092` (SSL listener)
- **Default Topic:** `my-topic`
- **Security Protocol:** SSL with mutual TLS authentication
- **Certificate Format:** JKS for Kafka broker, PEM for librdkafka clients

## Troubleshooting

- **Certificate errors:** Ensure certificates are generated before starting the broker
- **Connection refused:** Verify the broker is running with `docker compose ps`
- **ACL errors:** Make sure ACLs are configured after the broker starts
- **Python client errors:** Verify PEM certificates are extracted from JKS files

