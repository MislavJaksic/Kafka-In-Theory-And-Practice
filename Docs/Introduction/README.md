## [Introduction](http://kafka.apache.org/intro)

A Kafka cluster is made up of a single Zookeeper coordinator and at least one Kafka broker.  
Brokers store streams of messages in categories called topics.  

Topics are categories/feeds to which messages are published. Topics are implemented as a partitioned log.  
Topic partitions are ordered and immutable sequence of messages.  
Partitions are evenly scattered over many brokers.  
Each message is assigned an offset within the partition.  

Kafka brokers delete messages according to a retention policy.  

Kafka client APIs:  
```
Consumer    -> subscribes to topics and processes messages
Producer    -> publishes messages to a topic
Stream      -> consumes, transforms and publishes data to a topic
Connector   -> adapter between Kafka topics and an external systems
AdminClient -> Kafka topic and security
```
