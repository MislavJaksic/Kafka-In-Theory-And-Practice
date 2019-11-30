## [Accessing Kafka: Part 2 - Node ports](https://strimzi.io/2019/04/23/accessing-kafka-part-2.html)

### Node ports

`NodePort` is a `ServiceType`. It allocate a port on all nodes of Kubernetes.  
All traffic to this port is routed to the `Service` and `Pod`s behind it.  

Traffic is routed by `kube-proxy`.  
It doesn’t matter on which `Node` your `Pod` is running.  
`NodePort` will always route traffic to the correct `Pod`.

### Exposing Kafka using NodePort

```
# Note: `Kafka-Cluster` is `my-cluster` by default

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
        type: nodeport  # set to nodeport to use `NodePort` `Service`
        tls: false
    # ...
```

Clients need to reach each of broker directly.  
In Kubernetes each broker is in a `Pod`. Each broker has the `advertised.address` value set to the `Pod`'s DNS name.  
To make brokers visible outside Kubernetes Strimzi creates `N+1` `NodePort` `Service`s if there are `N` brokers:
* one is used to bootstrap Kafka clients, for the initial connection and receiving Kafka metadata
* N are used to address each broker directly

```
# Note: Kafka cluster name is `my-cluster`

          Per Pod Services:         
       |-->  k1-service ---------------> kafka-broker-1
Client --->  k2-service ---------------> kafka-broker-2
       |-->  k3-service ---------------> kafka-broker-3
       V                                   ^
     my-cluster-kafka-external-bootstrap --|  
                     ^
        External Bootstrap Service
```

### Accessing Kafka using per-pod services

Each `Pod` has a label `statefulset.kubernetes.io/pod-name`.  
Using that `Pod` label in the `Pod` selector of a `Service` definition allows Strimzi to target a single broker.  

```
# Note: `Kafka-Cluster` is `my-cluster` by default

apiVersion: v1
kind: Service
metadata:
  name: Kafka-Cluster-kafka-0
  # ...
spec:
  # ...
  selector:
    statefulset.kubernetes.io/pod-name: Kafka-Cluster-kafka-0
    strimzi.io/cluster: Kafka-Cluster
    strimzi.io/kind: Kafka
    strimzi.io/name: Kafka-Cluster-kafka
  type: NodePort
  # ...
```

Brokers must be configured to advertise their address.  
Clients connecting to the broker needs to connect to the:
* address of one of the `Node`s
* `NodePort` assigned to the `Service`

Strimzi configures these as the advertised addresses in the broker.  
Strimzi uses separate listeners for external and internal access.  

You can use a single advertised address.  
Using the address of the actual `Node` where the broker is running means less forwarding.  
Every time the broker restarts, the `Node` where it runs may change.  
Strimzi uses an `init container` to collect the address of the `Node` and uses it to configure the advertised address.  

`init container` gets the broker `Node` address from Kubernetes API.  
In the `Node` status the address is listed as one of the following:
* `External DNS`
* `External IP`
* `Internal DNS`
* `Internal IP`
* `Hostname`

`init container` will use the first one it finds.  

When the address is configured, the client can use the bootstrap `NodePort` `Service` to make the initial connection.  

```
|----------------------|  |----------------------|  |----------------------|
|        Node1         |  |        Node2         |  |        Node3         |
|                      |  | |------------------| |  |                      |
|                      |  | |    Kafka Pod     | |  |                      |
|                      |  | |                  | |  |                      |
|                      |  | |Advertised address| |  |                      |
|                      |  | |   Node2:31234    | |  |                      |
|                      |  | |--------^---------| |  |                      |
|                      |  |          |           |  |                      |
|               |--------------------|-------------------------|           |
|               |        Node-port-service (port 31234)        |           |
|               |--------------------^-------------------------|           |
|----------------------|  |----------|-----------|  |----------------------|
                                     |
                                   Client
```

After Strimzi configures everything:
* get the `NodePort` of the external bootstrap `Service`
* get the address of one of the `Node`s in Kubernetes
* test if you can connect to the Kafka cluster

```
$: kubectl get service Kafka-Cluster-kafka-external-bootstrap -o=jsonpath='{.spec.ports[0].nodePort}{"\n"}'  # -> Node-Port

$: kubectl get nodes  # ->
  # NAME       STATUS   ROLES   AGE   VERSION
  # Node-Name  Ready    ...     ...   ...
$: kubectl get node Node-Name -o=jsonpath='{range .status.addresses[*]}{.type}{"\t"}{.address}{"\n"}'  # ->
  # InternalIP   Node-Address
  # Hostname     Node-Name

$: bin/kafka-console-producer.sh --broker-list Node-Address:Node-Port --topic Topic-Name
```

See [Strimzi configuration, 3.1.6. Kafka broker listeners](../../Docs/Strimzi0.14/DeploymentConfig) for more information.  

### Troubleshooting node ports

You will most likely get an error.
```
$: bin/kafka-console-producer.sh --broker-list Node-Address:Node-Port --topic Topic-Name  # ->
  # Connection to node -1 (/Node-Address:Node-Port) could not be established.
```

```
$: bin/kafka-console-producer.sh --broker-list Kubectl-Server-Ip:Node-Port --topic Topic-Name  # ->
  # Connection to node 2 (/Node-Address:Node-Port) could not be established.
  # Connection to node 0 (/Node-Address:Node-Port) could not be established.
  # Connection to node 1 (/Node-Address:Node-Port) could not be established.
```

Compare if the following addresses:
```
# Note: the Kubectl-Server-Ip
$: kubectl config view  # ->
  # ...
  # - cluster:
  #     server: https//Kubectl-Server-Ip:Kubectl-Cluster-Server-Port
  #...
```

```
# Note: the Node-Address
$: kubectl get nodes  # ->
  # NAME       STATUS   ROLES   AGE   VERSION
  # Node-Name  Ready    ...     ...   ...
$: kubectl get node Node-Name -o=jsonpath='{range .status.addresses[*]}{.type}{"\t"}{.address}{"\n"}'  # ->
  # InternalIP   Node-Address
  # Hostname     Node-Name
```

```
# Note: the External-Address
$: kubectl exec Kafka-Cluster-kafka-0 -c kafka -it -- cat /tmp/strimzi.properties | grep advertised  # ->
  # advertised.listeners=
  # REPLICATION://...,
  # CLIENT://...,
  # CLIENTTLS://...,
  # EXTERNAL://External-Address:30572
```

If these are different:
* `Kubectl-Server-Ip`
* `Node-Address`
* `the External-Address`
then you can try and manually set the `advertisedHost` field.  

```
...
listeners:
  external:
    type: nodeport
    tls: false
    overrides:
      brokers:
      - broker: 0
        advertisedHost: Kubectl-Server-Ip
      - broker: 1
        advertisedHost: Kubectl-Server-Ip
      - broker: 2
        advertisedHost: Kubectl-Server-Ip
...
```
This setup will cause problems when scaling.  

Firewall may also cause problems.  

In Amazon AWS you need to enable access to the `Node`s / `NodePort`s in the security groups.  

### TLS support

TODO

### Customizations

TODO

### Pre-configured node port numbers

TODO

### Configuring advertised hosts and ports

TODO

### Pros and cons

TODO
