## [Introducing MirrorMaker 2.0 to Strimzi](https://strimzi.io/2020/03/30/introducing-mirrormaker2.html)

`MirrorMaker` replicates data across two Kafka clusters.  
Use `MirrorMaker` for disaster recovery and data aggregation.  

### MirrorMaker 2.0 - the Kafka Connect(ion)

`MirrorMaker 2.0` is based on Kafka Connect.  
Strimzi offers `KafkaMirrorMaker2` resource.  

### Bidirectional opportunities

`MirrorSourceConnector` creates `Remote topic`s in the target cluster.  
`Topic-0.Partition-0` source topic becomes `Cluster-0.Topic-0.Partition-0` destination topic.  

### Self-regulating topic replication

`MirrorMaker 2.0` synchronizes topic configuration.  

### Offset tracking and mapping

`MirrorCheckpointConnector` manages offsets for `ConsumerGroup`s using an `Offset sync` `Topic` and `Checkpoint` `Topic`.  
`Offset sync` `Topic` maps the source and target offsets.  
`Checkpoint` is emitted from each source cluster and replicated in the target cluster through the `Checkpoint` `Topic`.  
`Checkpoint` `Topic` maps the last committed offset in the source and target cluster for each `ConsumerGroup`.  

`RemoteClusterUtils.java` utility class provides automatic failover.  

```
<dependency>
    <groupId>org.apache.kafka</groupId>
    <artifactId>connect-mirror-client</artifactId>
    <version>2.4.0</version>
</dependency>
```

### Checking the connection

`MirrorHeartbeatConnector` periodically checks connectivity between clusters.  

### Unleashing MirrorMaker 2.0

```
apiVersion: kafka.strimzi.io/v1alpha1
kind: KafkaMirrorMaker2
metadata:
  name: Mirror-Maker-Name  # change
spec:
  version: 2.4.0
  connectCluster: "Target-Kafka-Cluster"  # change
  clusters:
  - alias: "Source-Kafka-Cluster"  # change
    bootstrapServers: Source-Kafka-Cluster-Ip-Port  # change
  - alias: "Target-Kafka-Cluster"  # change
    bootstrapServers: Target-Kafka-Cluster-Ip-Port  # change
  mirrors:
  - sourceCluster: "Source-Kafka-Cluster"  # change
    targetCluster: "Target-Kafka-Cluster"  # change
    sourceConnector: {}
```
