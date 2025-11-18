#!/usr/bin/env python3
"""
Kafka Producer with Mutual TLS Authentication

This script simulates the behavior of produce.sh, connecting to Kafka
with SSL/mTLS authentication and sending messages to a topic.
"""

import sys
from pathlib import Path
from confluent_kafka import Producer
from confluent_kafka.admin import AdminClient


# Configuration
BROKER = "localhost:29092"
TOPIC = "my-topic"
CERT_DIR = Path(__file__).parent.parent / "certCreation" / "secrets" / "client"


def get_ssl_config():
    """Get SSL configuration for Kafka producer using PEM format certificates."""
    ca_crt = CERT_DIR / "ca.crt"
    client_crt = CERT_DIR / "client.crt"
    client_key = CERT_DIR / "client.key"
    
    return {
        "security.protocol": "ssl",
        "ssl.ca.location": str(ca_crt),
        "ssl.certificate.location": str(client_crt),
        "ssl.key.location": str(client_key),
        "ssl.endpoint.identification.algorithm": "none",  # Disable hostname verification
    }


def delivery_callback(err, msg):
    """Callback function for message delivery confirmation."""
    if err is not None:
        print(f"Message delivery failed: {err}")
    else:
        print(f"Message delivered to {msg.topic()} [{msg.partition()}] at offset {msg.offset()}")


def check_topic_exists(admin_client, topic):
    """Check if the topic exists."""
    metadata = admin_client.list_topics(timeout=10)
    return topic in metadata.topics


def main():
    """Main function to produce messages to Kafka."""
    # Get SSL configuration
    config = get_ssl_config()
    
    # Create producer configuration
    producer_config = {
        "bootstrap.servers": BROKER,
        **config,
    }
    
    # Create producer
    producer = Producer(producer_config)
    
    # Check if topic exists
    admin_client = AdminClient(producer_config)
    if not check_topic_exists(admin_client, TOPIC):
        print(f"Warning: Topic '{TOPIC}' does not exist. It will be created automatically.")
        print("Note: This requires proper ACLs. Make sure the client has CREATE permission.")
    
    print(f"Kafka Producer started")
    print(f"Broker: {BROKER}")
    print(f"Topic: {TOPIC}")
    print(f"SSL: Enabled (Mutual TLS)")
    print("\nType messages and press Enter to send. Type 'exit' or 'quit' to stop.\n")
    
    try:
        message_count = 0
        while True:
            # Read message from stdin
            message = input("> ").strip()
            
            if message.lower() in ["exit", "quit", "q"]:
                break
            
            if not message:
                continue
            
            # Produce message
            message_count += 1
            producer.produce(
                TOPIC,
                value=message.encode("utf-8"),
                callback=delivery_callback
            )
            
            # Poll for delivery callbacks
            producer.poll(0)
        
        # Wait for all messages to be delivered
        print(f"\nFlushing {message_count} message(s)...")
        producer.flush(10)
        print("All messages delivered. Exiting.")
        
    except KeyboardInterrupt:
        print("\n\nInterrupted. Flushing messages...")
        producer.flush(10)
        print("Exiting.")
    except Exception as e:
        print(f"Error: {e}")
        producer.flush(10)
        sys.exit(1)


if __name__ == "__main__":
    main()
