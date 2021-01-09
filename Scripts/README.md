## Kafka scripts

### Cluster

Start Zookeeper:  
```
$: bin/zookeeper-server-start.sh config/zookeeper.properties
```

Start Kafka and open a JMX port:  
```
$: [JMX_PORT=PORT] bin/kafka-server-start.sh config/server.properties
```

Start Zookeeper and multiple Kafkas in separate terminals:
```
#!/bin/bash

path="/path/to/kafka"

gnome-terminal -e "bash -c '$path/bin/zookeeper-server-start.sh $path/config/zookeeper.properties'"
gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55555 $path/bin/kafka-server-start.sh $path/config/server.properties'"
gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55556 $path/bin/kafka-server-start.sh $path/config/server-1.properties'"
gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55557 $path/bin/kafka-server-start.sh $path/config/server-2.properties'"

# Note: server-X.properties -> "broker.id", "listeners" and "log.dirs" must be unique
```

### Topic

Create topic:  
```
$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test-topic

$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic replicated-test

$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic partitioned-test
```

List topics:  
```
$: bin/kafka-topics.sh --list --zookeeper localhost:2181
```

Inspect topic:  
```
$: bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic test-topic
```

### Producer

Create a console producer:  
```
$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic [--producer.config client.properties]
```

### Consumer

Create a console consumer:  
```
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic [--from-beginning] [--consumer.config client.properties]
```

### Connect

Start a file Connect:  
```
$: bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
```
