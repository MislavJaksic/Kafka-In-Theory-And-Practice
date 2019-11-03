## [4. Design](https://kafka.apache.org/documentation/#design)

### 4.1 Motivation

There should be a lot of data producers.  
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

### 4.8 Log Compaction

A topic partition will retain at least the last value for each message key.  
Why compact a topic? If there are lots of changes to keyed, mutable values.  
Consumers can then be restored without keeping track of all previous values.  

Use cases:
* database change subscription
* event sourcing
* journaling for high-availability

Log compaction is a type of retention policy.  
It is not based on time, but on key updates.  
When a key is updated, the previous value is deleted.  

Log compaction retention policy can be set per topic.  


#### Log Compaction Basics

```
        Delete  
       Retention       Cleaner                          Next
         Point          Point                           Write
           |              |                               |
           V              V                               V
|0|17|35|38|40|53|61|71|78|87|88|89|90|91|92|93|94|95|96|...
|<----------------------->|<--------------------------->|
         Log Tail                    Log Head
       (compacted)
# Note: a Kafka log with the offset for each message
```

Log Head is the same as any other Kafka log.   

Log compaction handles the Log Tail.   
Messages in the Log Tail retain their original offset.  

After compaction lower offsets are the same as the next highest offset.  
For example, 36, 37 and 38 all return the same message, that beginning with 38.  

A message with some key and a null value will delete the previous key value and be treated as a delete marker.  
Delete markers will be cleaned out after a period of time.  

Compaction doesn't block reads.  

```
Offset |0 |1 |2 |3 |4 |5 |6 |7 |8 |9  |10 |   Log
Key    |K1|K2|K1|K1|K3|K2|K4|K5|K5|K2 |K6 |  Before
Value  |V1|V2|V3|V4|V5|V6|V7|V8|V9|V10|V11| Compaction

Offset          |3 |4 |  |6 |  |8 |9  |10 |   Log
Key             |K1|K3|  |K4|  |K5|K2 |K6 |  After
Value           |V4|V5|  |V7|  |V9|V10|V11| Compaction
```

#### What guarantees does log compaction provide?

Log compaction guarantees that:  
1) any consumer that stays caught-up to within the head of the log will see every message that is written
2) compaction will never re-order messages
3) the offset for a message never changes
4) any consumer progressing from the start of the log will see at least the final state of all records in the order they were written  

#### Log Compaction Details

Log compaction is handled by the log cleaner, a pool of background threads.  
Each compactor thread:
1) chooses the log with the highest ratio of Log Head to Log Tail
2) creates a summary of the last offset for each key in the Log Head
3) recopies the log from beginning to end removing keys which have a later occurrence
4) the summary of the Log Head is just a space-compact hash table

#### Configuring The Log Cleaner

```
log.cleanup.policy=compact  # enables log compation
```

```
Topics:
min.compaction.lag.ms
max.compaction.lag.ms
Consumer:
delete.retention.ms
```

TODO
