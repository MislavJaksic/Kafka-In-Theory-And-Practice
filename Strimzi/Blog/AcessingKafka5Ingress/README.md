## [Accessing Kafka: Part 5 - Ingress](https://strimzi.io/2019/05/23/accessing-kafka-part-5.html)

### Kubernetes Ingress

Ingress is a layer 7 (L7) load balancer for HTTP or HTTPS traffic.  
`Ingress` defines rules for routing traffic to `Service`s and `Pod`s.   
`Ingress Controller` routes traffic according to the rules.  

Kubernetes has two official `Ingress Controller`s:
* NGINX controller
* GCE controller for Google Cloud

Most `Ingress Controller` rely on a `LoadBalancer` or `NodePort` `Service` which will get the external traffic to the `Ingress Controller`.  

`Ingress` offers the following for HTTP apps:
* TLS termination
* HTTP to HTTPS redirects
* HTTP request path routing

Strimzi uses TLS passthrough.  

### Using Ingress in Strimzi

TLS passthrough was tested with the NGINX `Ingress Controller` only. Read [more](https://kubernetes.github.io/ingress-nginx/user-guide/tls/#ssl-passthrough) about it.  

`Ingress` support in Strimzi is experimental.

`Ingress Controller`s can work directly with TCP connections.  
TLS passthrough has better support.  
TLS encryption is enabled when using `Ingress`.  

You have to specify the host address in the `Ingress` resource.  
If you don't have managed DNS (in `Minikube` for example), use wildcard DNS services.  
Set them to point to the IP address of your `Ingress Controller` (`broker-0.<minikube-ip-address>.nip.io`).  

```
|----------------------|  |----------------------|  |----------------------|
|        Node1         |  |        Node2         |  |        Node3         |
|                      |  | |------------------| |  |                      |
|                      |  | |    Kafka Pod     | |  |                      |
|                      |  | |--------^---------| |  |                      |
|                      |  |          |           |  |                      |
|               |--------------------|---------------------|               |
|               |           Kubernetes Service             |               |
|               |--------------------^---------------------|               |
|                      |  | |--------|---------| |  |                      |
|                      |  | |     Ingress      | |  |                      |
|                      |  | |--------^---------| |  |                      |
|               |--------------------|---------------------|               |
|               | Node-port-service/Load-balancer-service  |               |
|               |--------------------^---------------------|               |
|----------------------|  |----------|-----------|  |----------------------|
                                     |
                                   Client
```

Each Kafka broker has a `Service` and an `Ingress` resource.  
Bootstrap `Ingress` resource and `Service` is also created.  

You must specify `advertised.address`.  

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
        type: ingress
        configuration:
          bootstrap:
            host: bootstrap.192.168.64.46.nip.io
          brokers:
          - broker: 0
            host: broker-0.192.168.64.46.nip.io
          - broker: 1
            host: broker-1.192.168.64.46.nip.io
...
```

Download the server TLS certificate (replace my-cluster with the name of your cluster):!!!

```
$: kubectl get secret Kafka-Cluster-cluster-ca-cert -o jsonpath='{.data.ca\.crt}' | base64 -d > strimzi-ca.crt

$: keytool -import -trustcacerts -alias root -file strimzi-ca.crt -keystore truststore.jks -storepass password -noprompt
```

Use Kafka bootstrap to connect to the cluster.  
Because of TLS passthrough, connect to port 443.  !!!

```
$: bin/kafka-console-producer.sh --broker-list <bootstrap-host>:443 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=password --producer-property ssl.truststore.location=./truststore.jks --topic <your-topic>
```

### DNS annotations

TODO
