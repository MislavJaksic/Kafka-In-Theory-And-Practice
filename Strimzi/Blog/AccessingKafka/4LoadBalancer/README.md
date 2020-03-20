## [Accessing Kafka: Part 4 - Load Balancers](https://strimzi.io/2019/05/13/accessing-kafka-part-4.html)

### Load balancers

Load balancers distribute traffic.  
Layer 7 load balancers distribute individual requests (for example HTTP requests).  
Layer 4 load balancers distribute TCP connections.  

Load balancers are available in public and private clouds:
* Elastic Load Balancing services from Amazon AWS
* Azure Load Balancer in Microsoft Azure
* Google Cloud Load Balancing service from Google
* OpenStack

Set `Service` to `LoadBalancer` and Kubernetes will do the rest.  

### Using load balancers in Strimzi

Strimzi uses the Layer 4 load balancing.  
Strimzi creates a service for each broker.  

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: Kafka-Cluster
spec:
  kafka:
    # ...
    listeners:
      # ...
      external:
        type: loadbalancer  # set to loadbalancer to use `LoadBalancer` `Service`
        tls: false
    # ...
```

```
$: kubectl get service Kafka-Cluster-kafka-external-bootstrap -o=jsonpath='{.status.loadBalancer.ingress[0].hostname}{"\n"}'
OR
$: kubectl get service Kafka-Cluster-kafka-external-bootstrap -o=jsonpath='{.status.loadBalancer.ingress[0].ip}{"\n"}'

$: bin/kafka-console-producer.sh --broker-list LoadBalancer-Hostname-Ip:9094 --topic Topic-Name
```

### Advertised hostnames and ports

You can override `advertised.listeners`.  
```
# ...
listeners:
  external:
    type: route
    authentication:
      type: tls
    overrides:
      brokers:
      - broker: 0
        advertisedHost: 216.58.201.78
        advertisedPort: 12340
      - broker: 1
        advertisedHost: 104.215.148.63
        advertisedPort: 12341
      - broker: 2
        advertisedHost: 40.112.72.205
        advertisedPort: 12342
# ...
```

### Internal load balancers

Internal and public load balancers are not the same.  
Internal load balancers expose apps outside Kubernetes, but not to the whole world.  

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: Kafka-Cluster
spec:
  kafka:
    # ...
    template:
      externalBootstrapService:
        metadata:
          annotations:
            Internal-Load-Balancer-Cloud-Annotation: "Internal-Load-Balancer-Cloud-Value"
      perPodService:
        metadata:
          annotations:
            Internal-Load-Balancer-Cloud-Annotation: "Internal-Load-Balancer-Cloud-Value"
    # ...
```

### DNS annotations

TODO

### Pros and cons

Allow TCP routing.  
Provide excellent security.  
Good performance.  

Wasteful: N load balancers are doing nothing.  
Expensive.  
Adds latency.  
