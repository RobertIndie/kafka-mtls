docker run --rm -v "$(pwd)/certCreation/secrets/client:/etc/kafka/secrets" --network host  \
   apache/kafka:latest /opt/kafka/bin/kafka-console-consumer.sh \
   --bootstrap-server localhost:29092 --topic my-topic --from-beginning \
   --consumer.config /etc/kafka/secrets/certs.properties
