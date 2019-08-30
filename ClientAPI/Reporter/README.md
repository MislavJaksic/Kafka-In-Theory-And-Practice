## Reporter

A hidden construct mentioned only twice in Kafka's 70k word documentation.  

Reporters are described in:  
* kafka.metrics.reporters property
* metric.reporters property

Reporters are JARs which are run just after you run Kafka.  

There are two different types of Reporters:
```
Kafka Metrics Reporter -> reports Yammer/Dropwizard metrics
Metric Reporter        -> reports "client" metrics
```

### Kafka Metrics Reporter

For reporting (broker) Yammer/Dropwizard metrics.  

To activate, append this to Kafka's "server.properties":  
```
kafka.metrics.reporters=package.to.Class
```
 
The class must implement "kafka.metrics.KafkaMetricsReporter".  

Order of execution:
```
1) init()
```

### Metric Reporter

A program for reporting broker, consumer, producer, stream, Connect or AdminClient metrics.  

To activate, append this to Kafka's "server.properties":  
```
metric.reporters=package.to.Class
```

The class must implement "org.apache.kafka.common.metrics.MetricsReporter".  
It is notified about new metrics.  

Order of execution:
```
1) configure()  
2) init()  
3) metricChange()  
4) metricRemoval()  
5) close()  
```


### JAR location

Reporter JARs are placed in "/.../libs".  

### Errors

If a strange Scala error occurs it might be because of a dependency conflict. Use a selective UBER/fat JAR.  
