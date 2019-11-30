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

TLS passthrough was tested with the NGINX `Ingress Controller` only. `Ingress` support is experimental. Read [more](https://kubernetes.github.io/ingress-nginx/user-guide/tls/#ssl-passthrough) about it.  

Although some Ingress controllers also support working directly with TCP connections, TLS passthrough seems to be more widely supported. Therefore we decided to prefer TLS passthrough in Strimzi. That also means that when using Ingress, TLS encryption will always be enabled.

One of the main differences compared to OpenShift Routes is that for Ingress you have to specify the host address in your Kafka custom resource. The Router in OpenShift will automatically assign a host address based on the route name and the project. But in Ingress the host address has to be specified in the Ingress resource. You also have to take care that DNS resolves the host address to the ingress controller. Strimzi cannot generate it for you, because it does not know which DNS addresses are configured for the Ingress controller.

If you want to try it for example on Minikube or in other environments where you don’t have any managed DNS service to add the hosts for the Kafka cluster, you can use one of the wildcard DNS services such as nip.io or xip.io and set it to point to the IP address of your Ingress controller. For example broker-0.<minikube-ip-address>.nip.io.

Kafka clients connecting through Ingress controller

The way Strimzi uses Ingress to expose Kafka should already be familiar to you from the previous blog posts. We create one service as a bootstrap service and additional services for individual access to each of the Kafka brokers in your cluster. For each of these services we will also create one Ingress resource with the corresponding TLS passthrough rule.

Accessing Kafka using Ingress

When configuring Strimzi to use Ingress, you have to specify the type of the external listener as ingress and specify the ingress hosts used for the different brokers as well as for bootstrap in the configuration field:

apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: my-cluster
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
          - broker: 2
            host: broker-2.192.168.64.46.nip.io
    # ...

Using Ingress in your clients is very similar to OpenShift Routes. Since it always uses TLS Encryption, you have to first download the server certificate (replace my-cluster with the name of your cluster):

kubectl get secret cluster-name-cluster-ca-cert -o jsonpath='{.data.ca\.crt}' | base64 -d > ca.crt
keytool -import -trustcacerts -alias root -file ca.crt -keystore truststore.jks -storepass password -noprompt

Once you have the TLS certificate, you can use the bootstrap host you specified in the Kafka custom resource and connect to the Kafka cluster. Since Ingress uses TLS passthrough, you always have to connect on port 443. The following example uses the kafka-console-producer.sh utility which is part of Apache Kafka:

bin/kafka-console-producer.sh --broker-list <bootstrap-host>:443 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=password --producer-property ssl.truststore.location=./truststore.jks --topic <your-topic>

For example:

bin/kafka-console-producer.sh --broker-list bootstrap.192.168.64.46.nip.io:443 --producer-property security.protocol=SSL --producer-property ssl.truststore.password=password --producer-property ssl.truststore.location=./truststore.jks --topic <your-topic>

For more details, see the Strimzi documentation.
Customizations
DNS annotations

Many users are using some additional tools such as ExternalDNS to automatically manage DNS records for their load balancers. External DNS uses annotations on Ingress resources to manage their DNS names. It supports many different DNS services such as Amazon AWS Route53, Google Cloud DNS, Azure DNS etc.

Strimzi lets you assign these annotations through the Kafka custom resource using a field called dnsAnnotations. Using the DNS annotations is simple:

# ...
listeners:
  external:
    type: ingress
    configuration:
      bootstrap:
        host: kafka-bootstrap.mydomain.com
      brokers:
      - broker: 0
        host: kafka-broker-0.mydomain.com
      - broker: 1
        host: kafka-broker-1.mydomain.com
      - broker: 2
        host: kafka-broker-2.mydomain.com
    overrides:
      bootstrap:
        dnsAnnotations:
          external-dns.alpha.kubernetes.io/hostname: kafka-bootstrap.mydomain.com.
          external-dns.alpha.kubernetes.io/ttl: "60"
      brokers:
      - broker: 0
        dnsAnnotations:
          external-dns.alpha.kubernetes.io/hostname: kafka-broker-0.mydomain.com.
          external-dns.alpha.kubernetes.io/ttl: "60"
      - broker: 1
        dnsAnnotations:
          external-dns.alpha.kubernetes.io/hostname: kafka-broker-1.mydomain.com.
          external-dns.alpha.kubernetes.io/ttl: "60"
      - broker: 2
        dnsAnnotations:
          external-dns.alpha.kubernetes.io/hostname: kafka-broker-2.mydomain.com.
          external-dns.alpha.kubernetes.io/ttl: "60"
# ...

Again, Strimzi lets you configure the annotations directly. That gives you more freedom and hopefully makes this feature usable even when you use some other tool than External DNS. It also lets you configure other options than just the DNS names, such as the time-to-live of the DNS records etc.
Pros and cons

Kubernetes Ingress is not always easy to use because you have to install the Ingress controller and you have to configure the hosts. It is also available only with TLS encryption because of the TLS passthrough functionality which Strimzi uses. But it can offer an interesting option for clusters where node ports are not an option, for example for security reasons, and where using load balancers would be too expensive.

When using Strimzi Kafka operator with Ingress you always have to consider performance. The ingress controller usually runs inside your cluster as yet another deployment and adds an additional step through which your data has to flow between your clients and the brokers. You also need to scale it properly to ensure it will not be a bottleneck for your clients.

So Ingress might not be the best option when most of your applications using Kafka are outside of your Kubernetes cluster and you need to handle 10s or 100s MBs of throughput per second. However, especially in situations when most of your applications are inside your cluster and only a minority outside and when the throughput you need is not so high, Ingress might be a convenient option.

The Ingress API and the Ingress controllers can usually be installed on OpenShift clusters as well. But they do not offer any advantages over the OpenShift Routes. So on OpenShift, you should prefer the OpenShift Routes instead.
What’s next?

This was, for now, the last post in this series about accessing Strimzi Kafka clusters. In the 5 blog posts, we covered all the supported mechanisms that the Strimzi operator supports for accessing Kafka from both inside and outside of your Kubernetes or OpenShift cluster. We will, of course, keep posting blog posts on other topics and if something about accessing Kafka changes in the future, we will add new blog posts to this series.

If you liked this series, star us on GitHub and follow us on Twitter to make sure you don’t miss any of our future blog posts!
