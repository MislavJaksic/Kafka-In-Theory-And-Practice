## Reporter

A hidden construct mentioned only twice in Kafka's documentation.  

Mentions:  
*
*

### Metric Reporter

A program for reporting broker, consumer, producer, stream, connect or AdminClient metrics.  

Kafka server configuration properties:  
```
metric.reporters=package.to.Class
```
Metrics reporter class.  
The class implements org.apache.kafka.common.metrics.MetricsReporter.  
The class is notified about new metrics.  

Order of execution:  
1) configure()  
2) init()  
3) metricChange()  
4) metricRemoval()  
5) close()  

### Kafka Metrics Reporter

A program for reporting broker Yammer/Dropwizard metrics.  

Kafka server configuration properties:  
```
kafka.metrics.reporters=path.to.Class
```
Yammer metrics reporter class.  
The class implements kafka.metrics.KafkaMetricsReporter.  
JMX operations are exposed using an MBean class kafka.metrics.KafkaMetricsReporterMBean.  

Order of execution:  
1) init()  

### JAR location

Reporter JARs are placed in "kafka_x.y.z/libs/*.jar".  

### Errors

If a strange error occures, it might be due to a dependency conflict. Don't use an UBER jar.  