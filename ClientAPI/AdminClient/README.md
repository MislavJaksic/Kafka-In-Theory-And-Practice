## AdminClient

Kafka `AdminClient` class and  manages topics, brokers and security.  

### Functionalities

```
Resources -> broker, topic or unknown  
```

```
Create Admin Client -> specify at least the bootstrap.server  
```

```
Create Topic            -> create a new topic  
Create Topic Partitions -> increase the number of topic partitions  
Create ACL              -> Access Control List, security  
Create Delegation Token -> Kerberos, security  
```

```
Describe Topic            -> describe topic in cluster  
Describe Cluster          -> get nodes in cluster  
Describe Config           -> get broker/topic configs  
Describe Consumer Group   -> describe group in cluster  
Describe Log Dir          -> get info of all logs on a broker  
Describe ALC              -> security  
Describe Delegation Token -> security  
```

```
Update Resource Configs -> only topics currently
Update Log Directory -> for replicas
Update Partition Reassignment
```

```
Delete Topics           -> delete topic  
Delete Records          -> delete records with offset smaller then x in partition
Delete Consumer Group   -> delete group  
Delete Consumer -> by ID
Delete ALC              -> security  
Expire Delegation Token -> security  
```

```
List Consumer Group Offset -> get offset list  
List Consumer Groups       -> get group list  
List Topics                -> get topic list  
```

```
Elect Replica Leader -> for partitions
Get Metrics                    -> get AdminClient metadata
Increase Partition Number -> for topics
Renew Delegation Token
```
