## [Kafka whitepaper](https://www.microsoft.com/en-us/research/wp-content/uploads/2017/09/Kafka.pdf)  

Notes.  

### Chapter 1

```
Kafka - distributed messaging system for log data processing  
user activity and operational metrics  
used for search relevance, recommendations, ad targeting, spam protection, user status updates  

real-time usage of lots of data - problem
China Mobile up to 8TB
Facebook up to 6TB

log aggregators that push data into Hadoop for offline analysis:
Scribe, Data Highway, Flume

distributed and scalable
high throughput
real-time messaging system
online and offline log data consumption
```

### Chapter 2

```
other messanging systems
focus on delivery gatantee
increased complexity in design and implementation
a few pieces of log data can be lost
message producers cannot batch messages - each is a full TCP/IP roundtrip
have weak distributed support - partitioning data is hard
assume immediate message consumption - performance degrades

consumers implement a pull instead of a push model
enables consumer rewind
```

### Chapter 3

```
stream of messages is a topic
servers are called brokers
consumers pull data from subscribed topics in brokers

messages are bytes

consumer creates a message stream for a topic
messages will be distributed evenly across these streams
iterate over streams and process each message
stream never terminates, it blocks when it is empty
supports joint consumption of messages

kafka cluster made of many brokers
topic divided into partitions
broker stores one or more topic partition
many consumers and producers
```

#### Subchapter 3.1

```
partition has a logical log
log is implemented as a set of files of the same size
messages are appended to the file
files are flushed to disk after a predetermined number of messages have been appended

messages don't have an id
messages have a logical log offset

consumer's pull request has an offset from which the consumption begins and an acceptable number of bytes to fetch
broker has a sorted list of offsets for each file
consumers send an offset the broker finds the messages and then the consumer can calculate the next offset

each pull request has many messages
does not cache in memory
cache only in the page cache of the file system
no double buffering
retains cache even when restarting
little to no garbage collection - good VM language implementation (like Java)

message can be consumed multiple times
sending local file to a socket involves 4 data copying and 2 system calls
Linux sendfile API can do it in 2 copies and 1 system call

brokers do not track consumer message consumption
message deletion a problem
has a retention policy, abound 7 days
long retention possible becasue performance does not degrade with large data size

consumer can rewind to an old offset, reconsume data
important if a consumer experiences an error
easier to support in pull then push model
```

#### Subchapter 3.2

```
producers send to a random partition or a partition determined by a key and function

consumer group is a group of at least one consumer that jointly consume at least one topic

partition is the smallest unit of parallelism
messages from one partition are consumed only by a single consumer in a consumer group

no master node
use zookeeper for consensus services
zookeeper API is like file system paths
paths can be created, read, deleted and listed
can register a path watcher which sends a notification the children
of a path or the value of a path change
can create ephemeral (as oppose to persistent) path which means the path is removed when the client who created it is gone
can replicate data to multiple servers

kafka uses zookeeper
for detecting consumer or broker removal or addition
for rebalancing when a consumer or a broker are removed or added
for tracking consumed offset in each partition
each broker and consumer at startup register their information in a broker or consumer registry kept by zookeeper
broker registry has host name and port, set of topics and partitions stored in it
consumer registry has consumer group, set of topics to which it subscribes
each consumer group has a ownership registry and offset registry
ownership registry has one path for every subscribed partition and the consumer who own the partition (that is the path value is the id of the consumer)
offset registry has offsets of the last consumed message for each subscribed partition

zookeeper paths are ephemeral for broker registry, consumer registry, ownership registry
zookeeper paths are persistent for offset registry
if a broker fails, his partitions are deleted from the broker registry
if a consumer fails, it is deleted from the consumer registry and all partitions that is owns in the ownership registry
each consumer registers a zookeeper watcher on both the broker
registry and the consumer registry, and will be notified whenever
a change in the broker set or the consumer group occurs

when a change occurs, the consumers are rebalansed to determine a new set of partitions from which they should consume
if a consumer tries to take ownership of a partition still owned by another consumer the first consumer will release all owned partitions, wait and then rebalanse

consumers in a new consumer group begin either with the biggest or smallest offset on each subscribed partition
```

#### Subchapter 3.3

```
guarantees at least once delivery
duplication may occurs when a consumer crashes and the new consumer takes over with an offset that is slightly smaller then the last committed offset
if duplicates are not acceptable, implement your own logic using offsets or unique keys

messages from a single partition are delivered in order
avoid log corruption with cyclic redundancy check for each message
remove messages with bad CRC

if a broker crashes messages become unavailable
if a file system is damaged messages are lost
```

### Chapter 4

```
auditing system to make sure messages don't get lost
each message has a timestamp and server name
each message producer sends a monitoring event which records how many messages it sent
consumers can the count the messages and validate the count using the monitoring event
```

### Chapter 5

```
producers don't wait for ack - high publishing throughput
kafka has 9 bytes of overhead and activemq has 144

efficient storage - high consumer throughput
kafka uses sendfile API and does not care about delivery state
```

### Chapter 6

```
in the future
add data replication
async and sync replication

add real time stream capabilities
```
