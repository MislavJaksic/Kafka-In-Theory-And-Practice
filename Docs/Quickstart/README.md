## [Quickstart](http://kafka.apache.org/quickstart)

### Step 1: Download the code

```
$: java --version

# Note: download Kafka from https://www.apache.org/dyn/closer.cgi?path=/kafka/Kafka-Version/kafka_Scala-Version-Kafka-Version.tgz
$: tar -xzf kafka_Scala-Version-Kafka-Version.tgz
```

### Step 2: Start the server

```
$: bin/zookeeper-server-start.sh config/zookeeper.properties

$: bin/kafka-server-start.sh config/server.properties
```

### Step 3: Create a topic

```
$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic Topic-Name
$: bin/kafka-topics.sh --list --zookeeper localhost:2181  # -> Topic-Name
```

### Step 4: Start a producer

```
$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic Topic-Name
```

### Step 5: Start a consumer

```
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic Topic-Name --from-beginning
```

### Step 6: Create a Kafka cluster

Start multiple Kafka processes (brokers).  

Each Kafka broker has to have a unique `broker.id`, `listeners` and `log.dirs` `server.properties` value.  

### Step 7: Use Kafka Connect

Use Kafka Connect instead of custom integration code.  
Kafka Connect imports to and exports data from Kafka topics.  

Start Connect as a local dedicated process:  
```
$: bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
```
Configuration files define the Connector's behaviour.  
In this example:
* the first Connector is a "source"
* the second is a "sink"

Connectors will continuously process data as you append data to a file.  

### Step 8: Use Kafka Streams

Kafka Streams is a client library for building real time projects.  
Streams combines Java/Scala client side deployment and Kafka's server side cluster technology.  
