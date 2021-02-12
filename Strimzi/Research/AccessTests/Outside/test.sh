#!/bin/bash

KAFKA_PATH=/path/to/kafka
KAFKA_HOST_PORT=Kubectl-Server-IP:Node-Port
KAFKA_TOPIC=Kafka-Topic

gnome-terminal -- bash -c "$KAFKA_PATH/bin/kafka-console-producer.sh --broker-list $KAFKA_HOST_PORT --topic $KAFKA_TOPIC < messages.txt"

gnome-terminal -- bash -c "$KAFKA_PATH/bin/kafka-console-consumer.sh --bootstrap-server $KAFKA_HOST_PORT --topic $KAFKA_TOPIC --from-beginning"
