## [Accessing Kafka: Part 1 - Introduction](https://strimzi.io/2019/04/17/accessing-kafka-part-1.html)

Clients to have connect to the leader partition directly.  
The only data between brokers is due to replication.  

### Kafka’s discovery protocol

Protocol:
1) client connects to a broker for the first time
2) client receives metadata about the cluster
3) client uses metadata to connect to each broker

The broker addresses are either:
* based on the hostname of the machine on which it runs
* on the `advertised-listener` field

### What does it mean for Kafka on Kubernetes

Kubernetes exposes an app using a `Service`.  
`Service` is a layer 4 (L4) load-balancer.  
`Service` has a stable DNS address and forward connections to s `Pod`.  

Tricky if the clients needs:
* state stickiness
* data stickiness

With Kafka, `Service` can be used for the initial connection only.  
After that, a client needs to connect to a specific broker.  

Two options:
* route on layer 7 (L7): pretend a Kafka cluster has only one broker and then route traffic behind the scenes; for HTTP traffic, you can use an `Ingress`
* configure `advertised.listeners` field so clients can connect directly to the brokers; this is what Strimzi does

### Connecting from inside the same Kubernetes cluster

`StatefulSet` runs a Kafka broker cluster.  
`Headless Service` gives each broker `Pod` a stable DNS name.  
This DNS name is used as an `advertised.listeners` address for the Kafka broker.  

In Strimzi clients make:
* the first connection using a `Service` to get the metadata
* the following connections using the DNS names given to the `Pod`s by a `Headless Service`

```
# Note: Kafka cluster name is `my-cluster`

       |----------->  kafka-broker-1 (DNS: my-cluster-kafka-1.my-cluster-kafka-brokers)
Client ------------>  kafka-broker-2 (DNS: my-cluster-kafka-2.my-cluster-kafka-brokers)
       |----------->  kafka-broker-3 (DNS: my-cluster-kafka-3.my-cluster-kafka-brokers)
       *------*         ^                                 ^
              |         |                                 |
              V         |                                 |
 my-cluster-kafka-bootstrap                   my-cluster-kafka-brokers
              ^                                          ^
  External Bootstrap Service                      Headless Service
```

Strimzi has found the following during their DNS vs IP research:
* using DNS has its problems, but not as many as using IP

### Connecting from the outside

Use a separate Kafka `advertised.listeners`.  
