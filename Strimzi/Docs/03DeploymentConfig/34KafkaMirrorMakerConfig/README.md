## [3.4 Kafka Mirror Maker configuration](https://strimzi.io/docs/latest/#assembly-deployment-configuration-kafka-mirror-maker-str)

Nothing interesting.  

### 3.4.4. Using Strimzi with MirrorMaker 2.0.

#### ACL rules synchronization

ACL access to remote topics is possible if you are not using the `User Operator`.  

`SimpleAclAuthorizer` can, without `User Operator`, apply ACL rules to remote topics.  

`OAuth 2.0` AuthZ does not support access to remote topics in this way.  
