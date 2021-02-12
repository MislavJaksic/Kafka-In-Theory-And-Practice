## [6. Using the User Operator](https://strimzi.io/docs/latest/#assembly-using-the-user-operator-str)

### 6.2. Mutual TLS authentication (mTLS AuthN)

`mTLS` AuthN is used between `Kafka` and `Zookeeper` `Pod`s.  
`mTLS` AuthN in when both the server and the client present certificates (public keys).  
In one-way `TLS`, one party is the authenticator, the other presents an identity.  

Use `mTLS` AuthN when:
* client supports AuthN using `mTLS` AuthN
* it is necessary to use the `TLS` certificates rather than passwords
* you can reconfigure and restart clients so that they do not use expired certificates

#### 6.3. Creating a Kafka user with mutual TLS authentication

Prerequisites:
* `Kafka` resource has a `TLS` listener
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
    type: tls  # use mTLS
  authorization:
    type: simple  # use Kafka's ACL plugin SimpleAclAuthorizer
    acls:  # '*' is a wildcard
      - resource:
          type: topic
          name: Kafka-Topic
          patternType: literal
        operation: Read  # Consumer can Read
        host: "*"
      - resource:
          type: topic
          name: Kafka-Topic
          patternType: literal
        operation: Describe  # Consumer can Describe
        host: "*"
      - resource:
          type: group
          name: Consumer-Group-Name
          patternType: literal
        operation: Read  # Consumer can be a port of a Consumer Group
        host: "*"
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
