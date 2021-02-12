#!/bin/bash

# Before running the command, amke sure your `kubectl` is pointed at the correct Kubernetes.  
KAFKA_IMAGE=Kafka-Image  # Find at https://hub.docker.com/r/strimzi/kafka/tags
KAFKA_CLUSTER_NAME=Kafka-Cluster
KAFKA_TOPIC=Kafka-Topic
KAFKA_CLIENT_KUBERNETES_NAMESPACE=Kafka-Client-K8s-Namespace
KAFKA_KUBERNETES_NAMESPACE=Kafka-Cluster-K8s-Namespace

kubectl run kafka-producer -ti --image=$KAFKA_IMAGE --rm=true --restart=Never -n $KAFKA_CLIENT_KUBERNETES_NAMESPACE -- bin/kafka-console-producer.sh --broker-list $KAFKA_CLUSTER_NAME-kafka-bootstrap.$KAFKA_KUBERNETES_NAMESPACE:9092 --topic $KAFKA_TOPIC

kubectl run kafka-consumer -ti --image=$KAFKA_IMAGE --rm=true --restart=Never -n $KAFKA_CLIENT_KUBERNETES_NAMESPACE -- bin/kafka-console-consumer.sh --bootstrap-server $KAFKA_CLUSTER_NAME-kafka-bootstrap.$KAFKA_KUBERNETES_NAMESPACE:9092 --topic $KAFKA_TOPIC --from-beginning
