docker run --rm -v "$(pwd)/certCreation/secrets/client:/etc/kafka/secrets" --network host \
   apache/kafka:latest /opt/kafka/bin/kafka-topics.sh \
   --bootstrap-server localhost:29092 --list \
   --command-config /etc/kafka/secrets/certs.properties
