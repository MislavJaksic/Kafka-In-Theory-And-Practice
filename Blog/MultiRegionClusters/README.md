## [Multi-Region Clusters with Confluent Platform](https://www.confluent.io/blog/multi-region-data-replication/)

Stretch cluster: one Kafka cluster across multiple Data Centers

### Follower Fetching

Enabled by [KIP-392](../../KIP/392): allows Consumers to read from Follower replicas.

Rack awareness allows:
* Kafka brokers to better balance partition assignment
* Consumers o read from the closest rack

Rack algorithm:
1) Brokers configure `broker.rack` and `replica.selector.class`
2) Consumers configure `client.rack`
3) One consumer makes a fetch request to the leader
4) If the partition is rack aware and the replica selector is set, pick a `preferred read replica`
5) The consumer starts reading from the preferred read replica
6) Periodically, the consumer checks back with the leader for a refreshed replica selection

Kafka comes with a single implementation of `replica.selector.class`, but you can implement your own too.  

### Observers

Observers are unique to the Confluent Platform.  
They are asynchronous Follower replicas that cannot become a Leader or participate in ISR.  

Observers can be deployed in the secondary data center while the primary one has normal Follower replicas.

### Replica Placement

Three strategies:
* round robin
* rack-aware (see [KIP-36](../../KIP/36))
* manual assignment

Unique to the Confluent Platform:
* replica assignment as a set of matching constraints

It is similar to rack-aware placement, but allows you to specify the count of replicas in each `rack`.  

`rack` does not have to represent a physical rack, but rather a generic location label.  

### Multi-region ZooKeeper

Place the odd Zookeeper in an odd Data Center.  

If there are no metadata changes (broker failover, new consumers, new topics, partitions, ...) the latency and throughput is not affected.  
