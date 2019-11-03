<p align="center">
  <img width="200" src="images/kafka.png" alt="Kafka icon"></a>
</p>

## [Kafka](https://kafka.apache.org/)

Kafka is a distributed publish-subscribe messaging system.  
Kafka Streams can process streams of messages (it's similar to Apache Spark and Flink).  

### Install

[Instructions](Docs/Quickstart)

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
