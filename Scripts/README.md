## Kafka scripts

### Cluster

Start Zookeeper:  
```
$: sudo bin/zookeeper-server-start.sh config/zookeeper.properties
```

Start Kafka:  
```
$: sudo [JMX_PORT=PORT] bin/kafka-server-start.sh config/server.properties
```

Start different Kafkas:
```
server-X.properties -> "broker.id", "listeners" and "log.dirs" must be unique
$: sudo bin/kafka-server-start.sh config/server.properties &
$: sudo bin/kafka-server-start.sh config/server-1.properties &
$: sudo bin/kafka-server-start.sh config/server-2.properties &
```

Start Zookeeper and different Kafkas in seperate terminals:
```
#!/bin/bash

path="/path/to/kafka"

sudo gnome-terminal -e "bash -c '$path/bin/zookeeper-server-start.sh $path/config/zookeeper.properties'"
sudo gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55555 $path/bin/kafka-server-start.sh $path/config/server.properties'"
sudo gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55556 $path/bin/kafka-server-start.sh $path/config/server-1.properties'"
sudo gnome-terminal -e "bash -c 'sleep 5; JMX_PORT=55557 $path/bin/kafka-server-start.sh $path/config/server-2.properties'"
```

Start Zookeeper and Kafka in the same terminal:  
```
#!/bin/bash

path="/path/to/kafka"

sudo $path/bin/zookeeper-server-start.sh $path/config/zookeeper.properties
AND
sudo JMX_PORT=55555 $path/bin/kafka-server-start.sh $path/config/server.properties
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