### [8. Kafka Connect](http://kafka.apache.org/documentation.html#connect)

Kafka Connect transfers data between Kafka and an external system.

### [8.1 Overview](https://kafka.apache.org/documentation/#connect_overview)

Kafka Connect features:  
* standardized integration  
* distributed mode  
* REST interface  
* offset management  
* streaming integration  

### [8.2 User Guide](https://kafka.apache.org/documentation/#connect_user)

Kafka Connectors can be run in two modes:  
* standalone  
* distributed  

#### Standalone mode

In standalone mode the Connector is run in a single process.  

Run a Connector in standalone mode by executing:  
```
$: bin/connect-standalone.sh config/connect-standalone.properties [connector1.properties]..[connectorN.properties]

$: [runner-script] [worker.properties] [connector.properties] ...
```

Important worker properties:
```
bootstrap.servers=localhost:9092 -> Kafka brokers

key.converter=JsonConverter      -> transforms record keys from the Connect format and to a serialized Kafka format
value.converter=JsonConverter    -> transforms record values from the Connect format and to a serialized Kafka format

key.converter.schemas.enable=true
value.converter.schemas.enable=true

offset.flush.interval.ms=10000

plugin.path=/opt/connetors       -> path to Connector plugin (.jar, ...)
```

Connector properties for standalone mode:
```
name=jmx-connector           -> Connector name
connector.class=JMXConnector -> Connector's location within a package (.jar, ...)
tasks.max=1                  -> requested number of workers/tasks under a Connector

offset.storage.file.filename=/tmp/connect.offsets -> optional; file in which offset is stored  

# More properties can be added. They too will be passed to the Connector
zookeeper.ip_ports=...
kafka.destination.topic=...
```

These properties need to be set up to three times:
1) once for management access
2) once for Kafka sink tasks
3) once for Kafka source tasks

#### Distributed mode

In distributed mode Kafka balances work and ensures fault tolerance.  

Run a Connector in distributed mode by executing:  
```
$: bin/connect-distributed.sh config/connect-distributed.properties -> configure Connectors using REST API  
```
Offsets, configs and task status are stored in a Kafka topic.  
You should create it manually to ensure proper replication and partition number.  

Distributed mode configuration includes standalone configuration and:
* group.id - default connect-cluster; unique cluster name used when forming Connector clusters
* config.storage.topic - default connect-configs; topic for storing Connector and task configuration
* offset.storage.topic - default connect-offsets; topic for storing offsets
* status.storage.topic - default connect-status; topic for storing statuses

#### Configuring Connectors

Connector configurations are key-value pairs.  
In standalone mode they are defined in a properties file.  
In distributed mode they are defined in a JSON file.  

Sink Connectors must also set one of the following:  
* topics - CSV list of topics used as input for this sink Connector
* topics.regex - Java regex of topics used as input for this sink Connector

#### [Transformations](https://kafka.apache.org/documentation/#connect_transforms)

TODO  

#### [REST API](https://kafka.apache.org/documentation/#connect_rest)

Kafka Connectors expose a REST API for management and cross cluster communication with other Kafka Connectors.  

REST API server is configured using:  
* listeners - default "localhost:8083"; list of listeners; example: "listeners=http://localhost:8080,https://localhost:8443"

Kafka Connector cross cluster communication configuration:
* rest.advertised.host.name
* rest.advertised.port
* rest.advertised.listener

REST API endpoints can be seen [here](https://kafka.apache.org/documentation/#connect_rest).

### [8.3 Connector Development Guide](https://kafka.apache.org/documentation/#connect_development)

Connector types:
* source - import data into Kafka
* sink - export data from Kafka

Connectors are just responsible for breaking up a job into multiple Tasks.  

Task types:
* source
* sink

Tasks handle input/output streams of records with a schema.  

Streams are sequences of key-value records with IDs and offsets.  

#### [Developing a Simple Connector](https://kafka.apache.org/documentation/#connect_developing)

Kafka comes with a number of [Connector examples](https://github.com/apache/kafka/tree/trunk/connect/file/src).  

TODO
