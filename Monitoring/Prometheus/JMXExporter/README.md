## [JMX Exporter](https://github.com/prometheus/jmx_exporter)

Collector that can scrapes and exposes mBeans of a JMX target.  

Run as a Java Agent or a HTTP server.  
HTTP server has disadvantages:
* harder to configure
* cannot expose process metrics

### Use

#### Download and build

```
# Note: download release
$: pwd  #-> .../jmx_exporter-parent-x.y.z
$: mvn package
```

#### Configure

See [configuration examples](https://github.com/prometheus/jmx_exporter/tree/master/example_configs).  

#### Run

[Suggested port](https://github.com/prometheus/prometheus/wiki/Default-port-allocations) is 9404.  

Kafka:
```
# Note: run Zookeeper (makes sure it doesn't bind to the port)
$: export KAFKA_OPTS="-javaagent:.../jmx_prometheus_javaagent-x.y.z.jar=Exporter-Port:Kafka-Config.yaml"  # see Research
# Note: run Kafka
```

If you want to set the ENV VAR permanently:
```
# Note: be warned: this can cause errors!
# Note: run Zookeeper (makes sure it doesn't bind to the port)
$: sudo nano ~/.bashrc
    # ...
    # export KAFKA_OPTS="-javaagent:.../jmx_prometheus_javaagent-x.y.z.jar=Exporter-Port:Kafka-Config.yaml"
# Note: run Kafka
```

Generic:
```
$: java -javaagent:.../jmx_prometheus_javaagent-x.y.z.jar=Exporter-Port:Kafka-Config.yaml -jar JMX-Target.jar  # see Research
```

```
http://localhost:Exporter-Port/metrics
```

`/metrics` endpoint might exceed Prometheus default scrape timeout of 10 seconds due to how JMX works.

TODO


## [JMX monitoring](https://docs.oracle.com/javase/tutorial/jmx/)

JMX stands for Java Management Extensions.  
MBean stands for Managed Bean, it is a managed object.  
MBeans are managed by a MBean Server.  

TODO
