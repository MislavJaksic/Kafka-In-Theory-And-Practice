## Kafka Connect

Kafka Connect moves data between Kafka topics and an external system.  

### Construction

Connect comes in two flavors:
* Source Connect which writes messages to Kafka
* Sink Connect which reads messages from Kafka

Both types of Connect have:
* a manager class, Connector
* a worker class, Task

### Configuration

`connect-log4j.properties`

### Running

Kafka Source Connect order of execution:  
```
1)  Connector - version()  
2)  Connector - config()  
3)  Connector - start()  
4)  Connector - taskClass()  
5)  Connector - taskConfigs()  
6)  Task      - version()  
7)  Task      - start()  
8)  Task      - poll()  
9)  Task      - stop()  
10) Connector - stop()  
```

Kafka Connectors be run as either:  
* a single process in standalone mode
* a set of distributed processes in distributed mode

### Other

There are a number of [Connector examples](https://github.com/apache/kafka/tree/trunk/connect/file/src).  
