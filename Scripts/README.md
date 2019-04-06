## Kafka scripts

### Cluster

Start Zookeeper:  
```
$: bin/zookeeper-server-start.sh config/zookeeper.properties
```

Start Kafka:  
```
$: [JMX_PORT=PORT] bin/kafka-server-start.sh config/server.properties
```

Start different Kafkas:
```
server-X.properties -> "broker.id", "listeners" and "log.dirs" must be unique
$: bin/kafka-server-start.sh config/server.properties &
$: bin/kafka-server-start.sh config/server-1.properties &
$: bin/kafka-server-start.sh config/server-2.properties &
```

Start Zookeeper and different Kafkas in seperate terminals:
```
#!/bin/bash

path=

gnome-terminal -e "bash -c 'echo 1; sleep 3'"
gnome-terminal -e "bash -c 'echo 2; sleep 3'"
gnome-terminal -e "bash -c 'echo 3; sleep 3'"
```

Stop Kafkas:
```
$: ps

$: kill PID
```

### Topic

Create topic:  
```
$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic test-topic

$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic replicated-test

$: bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 3 --topic partitioned-test
```

List topics in cluster:  
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
$: bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test-topic
```

### Consumer

Create a console consumer:  
```
$: bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test-topic [--from-beginning]
```

### Connect

Start sample file Connect:  
```
bin/connect-standalone.sh config/connect-standalone.properties config/connect-file-source.properties config/connect-file-sink.properties
```