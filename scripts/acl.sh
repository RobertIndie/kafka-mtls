docker exec -t kafka-mtls-kafka-1 /opt/kafka/bin/kafka-acls.sh --bootstrap-server localhost:29092 --command-config /etc/kafka/secrets/certs.properties --add \
 --allow-principal "User:CN=client1.kafka.example.com,OU=TEST,O=LYDTECH,L=London,ST=LN,C=UK" \
 --operation Read --operation Write --operation Create --topic my-topic

docker exec -t kafka-mtls-kafka-1 /opt/kafka/bin/kafka-acls.sh --bootstrap-server localhost:29092 --command-config /etc/kafka/secrets/certs.properties --add \
--allow-principal "User:CN=client1.kafka.example.com,OU=TEST,O=LYDTECH,L=London,ST=LN,C=UK" --operation Read --group '*'
