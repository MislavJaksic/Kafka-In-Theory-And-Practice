## [3.1. Kafka cluster configuration](https://strimzi.io/docs/0.14.0/#assembly-deployment-configuration-kafka-str)

### 3.1.7. Authentication and Authorization (AuthN and AuthZ)

AuthN can be configured for each listener.  
AuthZ is configured for the entire cluster.  

#### Authentication (AuthN)

AuthN can be configured for each listener.  

AuthN `type`s:
* none (accepts all connections)
* `TLS` client AuthN (`mTLS`)
* `SASL` `SCRAM-SHA-512`
* `OAuth` 2.0 token based AuthN

`TLS` Client AuthN can only be done for `TLS` listeners.  

```
...
authentication:
  type: tls  # use mTLS
...
```

#### Configuring AuthN in Kafka brokers

Prerequisites:
* `Cluster Operator` is deployed
* `Kafka` resource exists

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
spec:
  kafka:
    ...
    listeners:
      tls:
        authentication:
          type: tls  # use mTLS
        ...
      external:
        authentication:
          type: tls  # use mTLS
...
```

#### Authorization (AuthZ)

AuthZ is configured for the entire cluster.  

AuthZ `type`s:
* simple (uses `Kafka`'s `Access Control List`s [`ACL`s] plugin)

Additionally, you can list the `superUsers`.  

`SimpleAclAuthorizer` is the default `Access Control List`s (`ACL`s) AuthZ plugin for `Kafka`.  
`ACL`s define which users have access to which resources.  

```
...
authorization:
  type: simple  # use Kafka's ACL plugin SimpleAclAuthorizer
...
```

`superUsers` can access all resources, regardless of ACLs.  

If `TLS` Client Authentication is used, the username will be: `CN=Certificate-Subject-Common-Name`.  
```
...
authorization:
  type: simple
  superUsers:
    - CN=fred
    - sam
    - CN=edward
...
```

#### Configuring authorization in Kafka brokers

Prerequisites:
* `Cluster Operator` is deployed
* `Kafka` resource exists

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
spec:
  kafka:
    ...
    authorization:
      type: simple  # use Kafka's ACL plugin SimpleAclAuthorizer
      superUsers:
        - CN=fred
        - sam
        - CN=edward
...
```

[KafkaUser resource](../../6UsingUserOperator/68KafkaUserResource)
