## [Using the User Operator](https://strimzi.io/docs/0.14.0/#assembly-using-the-user-operator-str)

TODO

### Overview of the User Operator component

TODO

### Mutual TLS authentication (mTLS AuthN)

mTLS AuthN is used between Kafka and Zookeeper `Pod`s.  
mTLS AuthN in when both the server and the client present certificates (public keys).  
In TLS, one party is the authenticator, the other presents an identity.  

Use mTLS AuthN when:
* client supports AuthN using mTLS AuthN
* it is necessary to use the TLS certificates rather than passwords
* you can reconfigure and restart clients so that they do not use expired certificates

#### Creating a Kafka user with mutual TLS authentication

Prerequisites:
* `Kafka` resource has a TLS listener
* `.spec.entityOperator` object exists in `Kafka`

```
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaUser
metadata:
  name: User-Name
  labels:
    strimzi.io/cluster: Kafka-Cluster
spec:
  authentication:
    type: tls
  authorization:
    type: simple
    acls:
      - resource:
          type: topic
          name: my-topic
          patternType: literal
        operation: Read
      - resource:
          type: topic
          name: my-topic
          patternType: literal
        operation: Describe
      - resource:
          type: group
          name: my-group
          patternType: literal
        operation: Read
```

### SCRAM-SHA authentication

TODO

### Creating a Kafka user with SCRAM SHA authentication

TODO

### Editing a Kafka user

TODO

### Deleting a Kafka user

TODO

### 6.8 Kafka User resource

[Instructions](68KafkaUserResource)
