## [Quickstart](http://kafka.apache.org/quickstart)

### Step 1: Download the code

```
$: java --version
# Note: setup JAVA_HOME

$: tar -xzf kafka_Scala-Version-Kafka-Version.tgz
```

### Step 2: Start the server

```
$: bin/zookeeper-server-start.sh config/zookeeper.properties

$: bin/kafka-server-start.sh config/server.properties
```

### Step 3: Create a topic

```
$: bin/kafka-topics.sh --list --zookeeper localhost:2181
  # [script_name] [command] [invoke_zookeeper] [host:port_of_broker]
$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test-topic
  # [script_name] [command] [invoke_zookeeper] [host:port_of_broker] [replication] [partitioning] [topic_name]
```

### Step 4: Send a publisher

```
$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test_topic
  # [script_name] [command] TODO
```

### Step 5: Start a consumer

```
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test_topic --from-beginning
  # [script_name] [command] [bootstrap_server_to_connect] [topic_name] [begin_reading_from/offset]
```

### Step 6: Create a Kafka cluster

To create a multi Kafka broker cluster start multiple Kafka processes.  

All Kafka brokers must have different "broker.id", "listeners" and "log.dirs" values.  

### Step 7: Use Kafka Connect

Use Kafka Connect instead of custom integration code.  
Kafka Connect imports to and exports data from Kafka topics.  

Start Connect in standalone mode, a local dedicated process:  
```
$: bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
  # [script_name] [connect_config] [connector_one_config] [connector_two_config]
```
Configuration files define the Connector's behaviour.  
In this example: the first Connector is a "source"; the second is a "sink".  

Connectors will continuously process data as you append data to the file.  

### Step 8: Use Kafka Streams

Kafka Streams is a client library for building real time projects.  
Streams combines Java/Scala client side deployment and Kafka's server side cluster technology.  
