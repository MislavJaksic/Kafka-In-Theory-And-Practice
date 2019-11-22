## [Strimzi in Minikube](https://strimzi.io/quickstarts/minikube/)

Quickstart review:
* has no clean up instructions
* cannot access Kafka from the host machine
* insultingly simple

Prerequisite:
* start Minikube (with at least 4GB memory)
* setup kubectl

```
$: kubectl create namespace kafka  # create namespace

$: curl -L https://github.com/strimzi/strimzi-kafka-operator/releases/download/0.14.0/strimzi-cluster-operator-0.14.0.yaml | sed 's/namespace: .*/namespace: kafka/' | kubectl apply -f - -n kafka  # download file, replace `namespace: myproject` with `namespace: kafka`, create `Custom Resource Definitions` (CRDs) and Strimzi Cluster Operator Deployment

$: kubectl apply -f https://raw.githubusercontent.com/strimzi/strimzi-kafka-operator/0.14.0/examples/kafka/kafka-persistent-single.yaml -n kafka  # create Kafka, Zookeeper, Cluster Entity Operator Deployments, Pods, ReplicaSets, StatefulSets, Services, ConfigMaps and PersistentVolumeClaims

$: kubectl wait kafka/my-cluster --for=condition=Ready --timeout=300s -n kafka  # wait until done

$: kubectl -n kafka run kafka-producer -ti --image=strimzi/kafka:0.14.0-kafka-2.3.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list my-cluster-kafka-bootstrap:9092 --topic my-topic  # produce messages

$: kubectl -n kafka run kafka-consumer -ti --image=strimzi/kafka:0.14.0-kafka-2.3.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server my-cluster-kafka-bootstrap:9092 --topic my-topic --from-beginning  # consume messages
```
