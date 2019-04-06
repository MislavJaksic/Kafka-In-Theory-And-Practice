## Kafka Connect

Kafka Connect moves data between Kafka topics and another system.  

### Construction

Connect comes in two flavours:
* Source Connect which import messages into Kafka
* Sink Connect which export messages from Kafka

Both types of Connect are made up of:
* Connector, a manager class
* Task, a worker class

### Configuration

connect-log4j.properties

### Running

Kafka Source Connect order of exeuction:  
```
1) Connector - version()  
2) Connector - config()  
3) Connector - start()  
4) Connector - taskClass()  
5) Connector - taskConfigs()  
6) Task - version()  
7) Task - start()  
8) Task - poll()  
9) Task - stop()  
10) Connector - stop()  
```

Kafka Connectors be run as either:  
* a single process in standalone mode
* a set of distributed processes in distributed mode

### Other

There are a number of [Connector examples](https://github.com/apache/kafka/tree/trunk/connect/file/src).  
