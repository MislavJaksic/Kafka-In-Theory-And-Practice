#!/bin/bash

KAFKA_PATH=/path/to/kafka_X

KAFKA_HOST=Kubectl-Server-Ip
KAFKA_PORT=31000
SOURCE_TOPIC=test-topic
SINK_TOPIC=test-topic

gnome-terminal -e "bash -c '$KAFKA_PATH/bin/kafka-console-producer.sh --broker-list $KAFKA_HOST:$KAFKA_PORT --topic $SOURCE_TOPIC'"

gnome-terminal -e "bash -c '$KAFKA_PATH/bin/kafka-console-consumer.sh --bootstrap-server $KAFKA_HOST:$KAFKA_PORT --topic $SINK_TOPIC'"
