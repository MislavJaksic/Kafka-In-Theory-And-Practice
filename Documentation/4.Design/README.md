## [4. Design](https://kafka.apache.org/documentation/#design)

### 4.1 Motivation

There should be lots of data producers.  
Data backlog should not effect performance.  
Data should be partitioned for speed.  
Data should be replicated for reliability.  

### 4.2 Persistence

Uses the filesystem and pagecache.  
The OS is responsible for keeping the cache and filesystem consistent.  
Messages are written to the filesystem as soon as possible without flushing them to the disk.  

This allows Kafka to retain a lot of data for a long time.  

### 4.3 Efficiency

Messages are bundled before being read, written or sent.  
Kafka uses a standardized binary message format which is shared by all producers, brokers, and consumers.  
A message log is just a set of files which store a sequence of messages.  
Messages are transfered from the pagecache to a socket using the sendfile and zero-copy API.  

Supports a lot of efficient batching format.  

### 4.4 Producer

Sends messages to the partition leader.  
All brokers can tell the producer which broker is the leader for which partition.  
Decide which partition should receive the messages.  

Can configure how many messages should it group together before sending them.  

### 4.5 Consumer

Pulls data from the broker.  
A pull model allows consumers to batch and reread messages.  

A consumer can decide to block itself to prevent polling an empty topic.  

Each topic partition is consumed by a single consumer within each subscribing consumer group.  
Consumer remember the message offset of the last consumed message.  

### 4.6 Message Delivery Semantics

Messages will not be lost once they are committed to the partition.  
Messages will be delivered at least once.  
You can choose to delivered messages in a way that will eliminate all duplicates.  
Producer can create a broadcast transaction which will either deliver messages all topics or to none.  

Producers can set their desired durability level.  

The consumer offset is stored by both the broker and the consumer.  
If the consumer fails another one can start reading from where the last one left off.  
Consumers will read messages at least once.  
Most of the time messages will be delivered exactly once.  
Kafka Streams, Kafka Connect and transactional producers/consumers read and write messages exactly once.  

### 4.7 Replication

TODO
