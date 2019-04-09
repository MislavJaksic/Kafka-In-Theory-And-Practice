<p align="center">
  <img width="200" src="images/kafka.png" alt="Kafka icon"></a>
</p>

## [Kafka](https://kafka.apache.org/)

Kafka is a distributed streaming platform. It brokers data between processes using a publish-subscribe
mechanism.  

### Nomenclature

```
Cluster   -> a group of Kafka nodes/instances/servers lead by a Zookeeper instance  
Broker    -> a Kafka deamon in charge of a node  
Node      -> a "database" for topic partitions  
Topic     -> a category/feed to which records are published  
Record    -> a message; has a key, a value and a timestamp  
Partition -> a partitioned log owned by a topic  
Replica   -> a copy of the cluster leader node  
Consumer  -> a program, a program which reads data to a topic  
Producer  -> a program, a program which publishes data to a topic  
Connect   -> a program, 
Stream    -> a program, a program which reads data, transforms data and publishes the same to another topic  
```

### [Introduction](http://kafka.apache.org/intro)

Kafka is run as a Zookeeper cluster of Kafka brokers.  
Brokers store streams of messages in categories called topics.  

Topics are categories/feeds to which messages are published. It is implemented as a partitioned log.  
Topic partitions are ordered and immutable sequence of messages.  
Partitions are scattered over many brokers.  
Each message is assigned an offset within the partition.  

Kafka broker cluster deletes messages according to a retention policy.  

Kafka client programs:  
```
Producer    -> publishes messages to topics
Consumer    -> subscribes to topics and processes messages
Streams     -> stream processor program; consumes messages from topics and produces output messages
Connector   -> an adapter between Kafka topics to outside systems
AdminClient -> Kafka topics and security administrative API
```

### [Quickstart](http://kafka.apache.org/quickstart)

#### Step 1

Install and configure Java.  

Then, download and install Kafka using a binary:  
```
$: tar -xzf kafka_x.x-x.x.x.tgz
```

#### Step 2

Start Zookeeper and Kafka:  
```
$: bin/zookeeper-server-start.sh config/zookeeper.properties
$: bin/kafka-server-start.sh config/server.properties
```

#### Step 3

Try a few topic scripts:  
```
$: bin/kafka-topics.sh --list --zookeeper localhost:2181 -> list topics
[script_name] [command] [invoke_zookeeper] [host:port_of_broker]
$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test-topic -> create topic
[script_name] [command] [invoke_zookeeper] [host:port_of_broker] [replication] [partitioning] [topic_name]
```

#### Step 4

Create a simple producer:  
```
$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test_topic -> command line producer
[script_name] [command] TODO
```

#### Step 5

Create a simple consumer:  
```
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test_topic --from-beginning -> command line consumer
[script_name] [command] [bootstrap_server_to_connect] [topic_name] [begin_reading_from/offset]
```

#### Step 6

Zookeeper cluster is made up of at least one Kafka broker.  
To create a multi broker cluster just start multiple Kafka processes.  

All Kafka brokers must have different "broker.id", "listeners" and "log.dirs" values.  

#### Step 7

Use Kafka Connect instead of custom integration code.  
Kafka Connect imports and exports data to and from Kafka topics.  

Start Connect in standalone mode, a local dedicated process:  
```
$: bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties -> file reader and writer Connector pair  
[script_name] [connect_config] [connector_one_config] [connector_two_config]
```
Configuration files define the Connector's behaviour.  
The first Connector is a "source" and the second Connector is a "sink".  

The Connectors will continuously process data as you append data to the file.  

#### Step 8

Kafka Streams is a client library for building real time projects.  
Streams combines Java/Scala client side deployment and Kafka's server side cluster technology.  
