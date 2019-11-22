## [Slides]

TODO

## [Video](https://www.youtube.com/watch?v=rzHQvImn2XY)

TODO

## [Demo](https://www.youtube.com/watch?v=KEPB7iG5Fgc)

[GitHub Scripts](https://github.com/seglo/kafka-in-jail)
I've noted only that which has been presented.  
There are more scripts and notes on the GitHub link (rebalancing partitions, monitoring with Prometheus, ...).  

### Install Strimzi

```
$: helm repo add strimzi https://strimzi.io/charts/
$: helm install strimzi/strimzi-kafka-operator
```

### Install Kafka Broker and Topic

```
$: kubectl apply -f simple-strimzi.yaml

$: kubectl apply -f simple-topic.yaml
```

### Connecting Clients

```
# Note: fully qualified service hostname:
  # IP: simple-strimzi-kafka-bootstrap.strimzi.svc.cluster.local
  # PORT: 9092 -> "Plaintext"
  #       9093 -> TLS
  #       9094 -> inter-broker
  #       9404 -> Prometheus

$: kubectl run -n strimzi --image strimzi/kafka producer --command -- opt/kafka/bin/kafka-producer-perf-test.sh --topic simple-topic --num-records 1000000 --record-size 100 --throughput 1000 --producer-props bootstrap.servers=simple-strimzi-kafka-bootstrap:9092
```

### Rolling Config Updates

Config update process:
1) watch Kafka resource change
2) apply new config to StatefulSet spec
3) starting from `Pod`-0, recreate it
4) Kafka `Pod` generates a new `broker.config`
5) wait until rediness check
6) repeat from step 3 until there are no more `Pod`s to update

```
# Note: `kubectl` can update resources on the fly

$: kubectl edit kafka simple-strimzi -n strimzi
  # edit `spec.kafka.config` with:
  # "auto.create.topics.enable: false"
```

### Scale Brokers Up

```
$: kubectl edit kafka simple-strimzi -n strimzi
  # edit `spec.kafka.replicas`
```

It's wise to rebalance partitions.  

### Rolling Broker Upgrades

Broker upgrade process:
1) upgrade Strimzi `Cluster Operator`
2) update config:
    a) (optional) set `log.message.format.version`
    b) set Kafka version

From 1.x to 2.x:
3) (optional) upgrade clients
4) (optional) set `log.message.format.version`

### Broker Replacement and Movement

```
$: kubectl delete pod kafka-1
```

#### 1) Find max bitrate per partition

Do a controlled test while looking at metrics:
* `kafka.server:type=BrokerTopicMetrics,name=BytesInPerSec`
* `kafka.server:type=BrokerTopicMetrics,name=BytesOutPerSec`

#### 2) Move partitions

Use Kafka partition reassignment tools.  

#### 3) Replace broker

```
$: kubectl delete pod kafka-1
```

#### 4) Rebalance partitions

Use Kafka partition reassignment tools.  

### MirrorMaker

Use case:
* disaster recovery
* multi data centre setup
    * active - passive cluster
    * active - active cluster (a lot more complex)

### Monitoring

Kubernetes + Prometheus + Grafana

Strimzi exposes a Prometheus Health Endpoint with Prometheus JMX Exporter.  

You can find it setup in `pipelines-strimzi.yaml`.  

### Clean up

```
$: kubectl delete deployment producer -n strimzi
$: kubectl delete kafkatopic simple-topic -n strimzi
$: kubectl delete kafka simple-strimzi -n strimzi
$: kubectl delete pvc -l strimzi.io/cluster=simple-strimzi -n strimzi
```
