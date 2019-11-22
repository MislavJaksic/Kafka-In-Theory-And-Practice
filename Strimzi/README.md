## [Strimzi](https://strimzi.io/)

[Strimzi release artefacts](https://github.com/strimzi/strimzi-kafka-operator/releases), YAML files, are referenced throughout the docs.  

### Deploy Strimzi

[Instructions](Docs/Strimzi0.14/GettingStarted)

#### Cluster Operator

```
# Note: create `Cluster Operator` in `K8s-Namespace` and make it watch `K8s-Namespace`

$: helm repo add strimzi https://strimzi.io/charts/
$: helm install Release-Name strimzi/strimzi-kafka-operator -n K8s-Namespace  

$: helm list -n K8s-Namespace
$: helm uninstall Release-Name -n K8s-Namespace
```

#### Deploy (ephemeral) Kafka

```
# Note: `Kafka-Cluster` is `my-cluster` by default in `*.yaml`

$: kubectl apply -f Research/kafka-ephemeral.yaml -n K8s-Namespace
$: kubectl apply -f examples/kafka/kafka-persistent.yaml -n K8s-Namespace

$: kubectl delete kafka.kafka.strimzi.io/Kafka-Cluster -n K8s-Namespace
```

### Connect to Strimzi

#### NodePort

```
$: bin/kafka-console-producer.sh --broker-list Kubectl-Server-IP:Node-Port --topic Topic-Name
$: bin/kafka-console-consumer.sh --bootstrap-server Kubectl-Server-IP:Node-Port --topic Topic-Name --from-beginning
```

[Instructions](Blog/AccessingKafka2Nodeports)
