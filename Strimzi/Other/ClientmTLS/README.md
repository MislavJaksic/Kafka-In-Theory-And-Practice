## [Client Side mTLS](https://smallstep.com/hello-mtls/doc/client/kafka-cli)

### How to use TLS, client authentication, and CA certificates in Kafka Command Line Tools

TODO

### Open a connection from Kafka Command Line Tools using mutual TLS

You will need:
* a cluster certificate (to AuthN the cluster)
* a private-public key pair (with which to sign messages)

```
$: openssl pkcs12 -export -in User-Name.crt -inkey User-Name.key -name User-Name > User-Name.p12  # ->
  # Enter Export Password: Key-Password
  # Verifying - Enter Export Password: Key-Password
```

```
$: keytool -importkeystore -srckeystore User-Name.p12 -destkeystore keystore.jks -srcstoretype pkcs12 -alias User-Name  # ->
  # Enter destination keystore password: Keystore-Password
  # Re-enter new password: Keystore-Password
  # Enter source keystore password: Key-Password
```

```
$: keytool -keystore truststore.jks -alias root -import -file Cluster-CA.crt
  # Enter keystore password: Truststore-Password
  # Re-enter new password: Truststore-Password
  # ...
  # Trust this certificate? yes
```

```
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
```

```
$: bin/kafka-console-producer --broker-list Kubectl-Server-IP:Node-Port -topic Topic-Name --producer.config client.properties
$: bin/kafka-console-consumer --bootstrap-server Kubectl-Server-IP:Node-Port -topic Topic-Name --consumer.config client.properties
```
