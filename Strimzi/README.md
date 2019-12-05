## [Strimzi](https://strimzi.io/)

[Strimzi release artefacts](https://github.com/strimzi/strimzi-kafka-operator/releases), YAML files, are referenced throughout the docs.  

### Deploy Strimzi

#### Cluster Operator

```
# Note: create `Cluster Operator` in `K8s-Namespace` and make it watch `K8s-Namespace`

$: helm repo add strimzi https://strimzi.io/charts/
$: helm install Release-Name strimzi/strimzi-kafka-operator -n K8s-Namespace  

$: helm list -n K8s-Namespace
$: helm uninstall Release-Name -n K8s-Namespace
```

#### Deploy Kafka

```
# Note: rename `my-cluster` in the templates
# Note: configure `.spec.entityOperator`

$: kubectl apply -f examples/kafka/kafka-ephemeral.yaml

$: kubectl delete -f examples/kafka/kafka-XYZ.yaml
```

#### Deploy KafkaTopic

Manage them with your client's `Deployment`.  

```
$: kubectl apply -f examples/topic/kafka-topic.yaml
```

#### Deploy KafkaUser

Manage them with your client's `Deployment`.  

```
$: kubectl apply -f examples/topic/kafka-user.yaml
```

### Connect to Strimzi

#### NodePort

```
$: bin/kafka-console-producer.sh --broker-list Kubectl-Server-IP:Node-Port --topic Topic-Name
$: bin/kafka-console-consumer.sh --bootstrap-server Kubectl-Server-IP:Node-Port --topic Topic-Name --from-beginning
```

You can also enable TLS.  

[Instructions](Blog/AccessingKafka2Nodeports)
