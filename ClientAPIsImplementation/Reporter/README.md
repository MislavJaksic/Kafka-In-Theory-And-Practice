## Reporter

A hidden construct mentioned only twice in Kafka's documentation.  

Reporters are mentioned in:  
* kafka.metrics.reporters property
* metric.reporters property

Reporters are JARs which are run just after you run Kafka.  

There are two different types of Reporters:
```
Kafka Metrics Reporters -> reports Yammer/Dropwizard metrics
Metric Reporters        -> reports "client" metrics
```



### Kafka Metrics Reporter

For reporting Broker Yammer/Dropwizard metrics.  

Append the following to Kafka server.properties:  
```
kafka.metrics.reporters=path.to.Class
```
 
The class must implement kafka.metrics.KafkaMetricsReporter.  

Order of execution:  
1) init() 



### Metric Reporter

A program for reporting Broker, Consumer, Producer, Stream, Connect or AdminClient metrics.  

Append the following to Kafka server.properties:  
```
metric.reporters=package.to.Class
```

The class must implement org.apache.kafka.common.metrics.MetricsReporter.  
It is notified about new metrics.  

Order of execution:  
1) configure()  
2) init()  
3) metricChange()  
4) metricRemoval()  
5) close()  



### JAR location

Both types of Reporter JARs are placed in /.../kafka_x.y.z/libs.  

### Errors

If a strange Scala error occurs, it might be cause by a dependency conflict. Use a selective UBER jar.  
