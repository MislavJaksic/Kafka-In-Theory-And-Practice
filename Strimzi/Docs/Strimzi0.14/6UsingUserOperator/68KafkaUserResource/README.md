## [Kafka User resource](https://strimzi.io/docs/0.14.0/#ref-kafka-user-using-uo)

`KafkaUser` declares a user with its AuthN and AuthZ mechanisms and access rights.  

### Authentication (AuthN)

#### TLS Client Authentication

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
...
```

Creates a `Secret` with:
* public (a.k.a. certificate) and private key to be used for TLS Client Authentication
* public key of the client certification authority which was used to sign the user certificate

All keys are in X509 format.  

```
apiVersion: v1
kind: Secret
metadata:
  name: User-Name  # same name as `KafkaUser`
  labels:
    strimzi.io/kind: KafkaUser
    strimzi.io/cluster: Kafka-Cluster
type: Opaque
data:
  ca.crt: ...  # public key of the client Certificate Authority
  user.crt: ...  # public key of the user
  user.key: ...  # private key of the user
```

#### SCRAM-SHA-512 Authentication

TODO

### Authorization (AuthZ)

#### Simple authorization

`SimpleAclAuthorizer` is the default Access Control Lists (ACLs) AuthZ plugin for Kafka.  
ACL rules grant access rights to users.  
`AclRule` is specified as a set of properties:
* `resource`
* `type`
* `operation`
* `host`

##### resource

`type`s:
* `topic`
* `group` (for Consumer Groups)
* `cluster`
* `transactionalId`

`cluster` type resources have no name, while for others it has to b specified.  
`name`s can be a:
* `literal` (taken as is)
* `prefix` using the `patternType` (taken as a prefix and will apply the rule to all resources with names starting with the prefix)

##### type

`type` is either `allow` or `deny`.  

##### operation

Supported `operation`s:
* `Read`
* `Write`
* `Delete`
* `Alter`
* `Describe`
* `All`
* `IdempotentWrite`
* `ClusterAction`
* `Create`
* `AlterConfigs`
* `DescribeConfigs`

Only certain operations work with each resource.  
[Kafka Security: Authorization and ACLs](https://kafka.apache.org/documentation/#security_authz)  

##### host

Specifies a remote host from which the rule is allowed or denied.  

See [AclRule](https://strimzi.io/docs/0.14.0/#type-AclRule-reference) for more information.  

```
apiVersion: kafka.strimzi.io/v1beta1
kind: KafkaUser
metadata:
  name: User-Name
  labels:
    strimzi.io/cluster: Kafka-Cluster
spec:
  ...
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
          patternType: prefix
        operation: Read
```

#### Super user access to Kafka brokers

`superUsers` defined in a the Kafka broker configuration ignore ACLs.  
