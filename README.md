<p align="center">
  <img width="200" src="images/kafka.png" alt="Kafka icon"></a>
</p>

## [Kafka](https://kafka.apache.org/)

Kafka is a distributed publish-subscribe messaging system.  
Kafka Streams can process streams of messages (similar to Apache Spark and Flink).  

### Nomenclature

```
Cluster   -> a group of Kafka brokers lead by a Zookeeper instance
Broker    -> a Kafka daemon/node/instance/server
Topic     -> a category/feed to which records are published
Record    -> a message; has a key, a value and a timestamp
Partition -> a partitioned log; many make up a topic; each has a broker leader
Replica   -> a copy of a partition; brokers who own them are followers

Consumer  -> a program which reads data from a topic
Producer  -> a program which writes data to a topic
Connect   -> a program which transfers data between Kafka and an external system
Stream    -> a program which consumes, transforms and publishes data from one topic to another
```

### [Introduction](http://kafka.apache.org/intro)

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
