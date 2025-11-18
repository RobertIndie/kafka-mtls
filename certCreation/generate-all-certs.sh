#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "=== Generating CA Certificate ==="
bash create-ca.sh

echo ""
echo "=== Generating Server Certificate ==="
bash create-server-cert.sh

echo ""
echo "=== Generating Client Certificate ==="
bash create-client-cert.sh

echo ""
echo "=== Certificate Generation Complete ==="
echo "Server certificates:"
ls -lh secrets/server/*.jks 2>/dev/null || echo "No server certificates found"
echo ""
echo "Client certificates:"
ls -lh secrets/client/*.jks 2>/dev/null || echo "No client certificates found"

