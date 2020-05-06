## [Strimzi](https://strimzi.io/)

[Strimzi release artefacts](https://github.com/strimzi/strimzi-kafka-operator/releases), YAML files, are referenced throughout the documentation.  

### Create

#### Cluster Operator

```
$: kubectl create namespace K8s-Strimzi-Namespace

$: helm repo add strimzi https://strimzi.io/charts/
$: helm install Release-Name strimzi/strimzi-kafka-operator -f config-operator.yaml -n K8s-Strimzi-Namespace  # see Research

$: helm list -n K8s-Strimzi-Namespace
$: helm uninstall Release-Name -n K8s-Strimzi-Namespace
```

#### Deploy Kafka

```
$: kubectl apply -f kafka-nodeport.yaml  # see Research

$: kubectl delete -f kafka-nodeport.yaml
```

#### Deploy KafkaTopic

```
$: kubectl apply -f topic.yaml  # see Research
```

#### Deploy KafkaUser

```
$: kubectl apply -f user.yaml  # see Research
```

### Access

#### NodePort

```
$: bin/kafka-console-producer.sh --broker-list Kubectl-Server-IP:Node-Port --topic Topic-Name
$: bin/kafka-console-consumer.sh --bootstrap-server Kubectl-Server-IP:Node-Port --topic Topic-Name [--from-beginning]
```

#### NodePort using TLS

```
$: kubectl get secret Kafka-Cluster-cluster-ca-cert -o jsonpath='{.data.ca\.crt}' | base64 -d > Cluster-CA.crt

$: keytool -keystore truststore.jks -alias root -import -file Cluster-CA.crt
  # Enter keystore password: Truststore-Password
  # Re-enter new password: Truststore-Password
  # ...
  # Trust this certificate? yes

$: cat client.properties  # ->
  # # enable TLS
  # security.protocol=SSL
  # # server public key (one-way TLS)
  # ssl.truststore.location=truststore.jks
  # ssl.truststore.password=Truststore-Password

$: bin/kafka-console-producer --broker-list Kubectl-Server-IP:Node-Port -topic Topic-Name --producer.config client.properties
$: bin/kafka-console-consumer --bootstrap-server Kubectl-Server-IP:Node-Port -topic Topic-Name [--from-beginning] --consumer.config client.properties
```

[Instructions](Blog/AccessingKafka2Nodeports)

#### LoadBalancer

```
$: bin/kafka-console-producer.sh --broker-list LoadBalancer-Hostname-Ip:9094 --topic Topic-Name
```

### Monitoring

[Instructions](Docs/8IntroducingMetrics)

#### Using kube-prometheus

[Deploy kube-prometheus](https://github.com/MislavJaksic/Knowledge-Repository/tree/master/Technology/DevOps/Observability/Monitoring/Prometheus/kube-prometheus)

```
$: kubectl apply -f service-monitor.yaml  # see Research
```

### Cluster replication

TODO

### Security

#### mTLS

```
$: kubectl get secret Kafka-Cluster-cluster-ca-cert -o jsonpath='{.data.ca\.crt}' | base64 -d > Cluster-CA.crt

$: keytool -keystore truststore.jks -alias root -import -file Cluster-CA.crt
  # Enter keystore password: Truststore-Password
  # Re-enter new password: Truststore-Password
  # ...
  # Trust this certificate? yes


$: kubectl get secret User-Name -o jsonpath='{.data.user\.crt}' | base64 -d > User-Name.crt
$: kubectl get secret User-Name -o jsonpath='{.data.user\.key}' | base64 -d > User-Name.key

$: openssl pkcs12 -export -in User-Name.crt -inkey User-Name.key -name User-Name > User-Name.p12  # ->
  # Enter Export Password: Key-Password
  # Verifying - Enter Export Password: Key-Password

$: keytool -importkeystore -srckeystore User-Name.p12 -destkeystore keystore.jks -srcstoretype pkcs12 -alias User-Name  # ->
  # Enter destination keystore password: Keystore-Password
  # Re-enter new password: Keystore-Password
  # Enter source keystore password: Key-Password


$: cat client.properties  # ->
  # # enable TLS
  # security.protocol=SSL
  # # server public key (one-way TLS)
  # ssl.truststore.location=truststore.jks
  # ssl.truststore.password=Truststore-Password
  # # client public-private key pair (mTLS)
  # ssl.keystore.location=keystore.jks
  # ssl.keystore.password=Keystore-Password
  # ssl.key.password=Key-Password

$: bin/kafka-console-producer --broker-list Kubectl-Server-IP:Node-Port -topic Topic-Name --producer.config client.properties
$: bin/kafka-console-consumer --bootstrap-server Kubectl-Server-IP:Node-Port -topic Topic-Name [--from-beginning] --consumer.config client.properties
```

[Instructions](Other/ClientmTLS)
