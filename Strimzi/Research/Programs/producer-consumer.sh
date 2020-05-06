#!/bin/bash

KAFKA_PATH=/path/to/kafka_X  # change
KAFKA_HOST_PORT=Kubectl-Server-Ip:31000  # change
KAFKA_TOPIC=Topic-Name  # change

echo "Enter a few messages after you see '>'."

$KAFKA_PATH/bin/kafka-console-producer.sh --broker-list $KAFKA_HOST_PORT --topic $KAFKA_TOPIC

echo ""
echo "Echoing messages:"

$KAFKA_PATH/bin/kafka-console-consumer.sh --bootstrap-server $KAFKA_HOST_PORT --topic $KAFKA_TOPIC --from-beginning
