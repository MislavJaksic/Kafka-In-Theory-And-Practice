## [KIP-392: Allow consumers to fetch from closest replica](https://cwiki.apache.org/confluence/display/KAFKA/KIP-392%3A+Allow+consumers+to+fetch+from+closest+replica)

### Motivation

Kafka clusters can span many datacenters.  
Kafka rack is equivalent to an AWS region availability zone.  
Consumers can only fetch from Leader replicas.  

Proposition: allow consumers to fetch from the closest replica.  

### Follower Fetching

TODO

### Finding the preferred follower

Broker will decide the preferred replica based on the information from the client.  

Allow users to provide a `ReplicaSelector` plugin to the Broker in order to handle the logic. Brokers select the plugin with `replica.selector.class`.  

### Public Interfaces

#### Consumer API

`broker.rack` identifies the location of the Broker.  

#### Broker API

`replica.selector.class` selects logic to determine the preferred replica to fetch from.  

They provide many interfaces and two implementations:
* return partition Leader
* return exact match rackId

JMX metric under `kafka.consumer:type=consumer-fetch-manager-metrics,client-id=*,topic=*,partition=*` called `preferred-read-replica` will have a value equal to the broker ID which the consumer is currently fetching from. If Missing or -1, it is fetching from the Leader.  
