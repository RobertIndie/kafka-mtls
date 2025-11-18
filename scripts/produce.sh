docker run --rm -v "$(pwd)/certCreation/secrets/client:/etc/kafka/secrets" --network host -ti \
   apache/kafka:latest /opt/kafka/bin/kafka-console-producer.sh \
   --bootstrap-server localhost:29092 --topic my-topic \
   --producer.config /etc/kafka/secrets/certs.properties
