## [Disaster Recovery for Multi-Region Kafka at Uber](https://eng.uber.com/kafka/)

[uReplicator: Uber Engineering’s Robust Apache Kafka Replicator](https://eng.uber.com/ureplicator-apache-kafka-replicator/)  
[uReplicator: Improvement of Apache Kafka Mirrormaker](https://github.com/uber/uReplicator)  

### Apache Kafka at Uber

Uber processes trillion messages and several petabytes through Kafka.  

### Multi-region Kafka at Uber

Kafka has region-failover. Services assume data is available in Kafka.  

Producer publish Records into Region Clusters for better performance. If a Region Cluster is unavailable, Producers produce to a different Region Cluster.  

Region Clusters are asynchronously replicated to Aggregate Clusters using uReplicator. uReplicator extends the design of MirrorMaker.  

### Consuming from multi-region Kafka clusters

#### Active/active consumption

For example, if you want to compute the surge price, you consumer from the aggregate cluster and compute the result separately in each region. One region is primary and all others are redundant.

An all-active-service coordinates the update services in the regions and assigns one primary region to update. What this means is a mystery.  

If the primary region fails, the all-active service assigns another region as primary.  

The apps store their state in the infrastructure layer and become stateless.  

#### Active/active consumers

Only one consumer consumes data from the primary cluster.  

Multi-region Kafka tracks its consumption progress and replicates the offset to other regions.

Syncing offsets is not just a matter of taking the high or low watermark (latest or earliest message). Messages can also be out of order.  

uReplicator and offset managers checkpoint and syncs them across the region.  

ToDo: offset mapping algorithm
