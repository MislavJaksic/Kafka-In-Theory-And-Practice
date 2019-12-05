## [Getting started with Strimzi](https://strimzi.io/docs/latest/#getting-started-str)

Strimzi benefits from integration with OpenShift (Kubernetes distribution).  

<The guide assumes `kubectl` can reach Kubernetes.  

[Strimzi release artefacts](https://github.com/strimzi/strimzi-kafka-operator/releases), YAML files, are referenced throughout the docs.  
`Cluster Operator` can be deployed using a Helm chart.  

### Custom Resources

`CustomResourceDefinition`s (CRDs) extend the Kubernetes API.  
`CustomResource`s are instances of CRDs.  
CRDs and `CustomResource`s are defined as YAML files.  

CRDs require a one-time installation in a cluster.  
A CRD defines a new `kind` of resource, such as `kind:Kafka`.  

```
apiVersion: kafka.strimzi.io/v1beta1        apiVersion: kafka.strimzi.io/v1beta1
kind: CustomResourceDefinition              kind: KafkaTopic  # reference CRD
metadata:  # to identify CRD                metadata:
  name: kafkatopics.kafka.strimzi.io          name: my-topic
  labels:                                     labels:
    app: strimzi                                strimzi.io/cluster: Kafka-Cluster-Name  # references Kafka
spec:                                       spec:
  group: kafka.strimzi.io                     partitions: 1
  versions:                                   replicas: 1
    v1beta1                                   config:
  scope: Namespaced                             retention.ms: 7200000
  names:                                        segment.bytes: 1073741824
    # ...                                   status:
    singular: kafkatopic                      conditions:
    plural: kafkatopics                         lastTransitionTime: "2019-08-20T11:37:00.706Z"
    shortNames:                                 status: "True"
    - kt                                        type: Ready
  additionalPrinterColumns:                   observedGeneration: 1
      # ...                                   / ...
  subresources:                             
    status: {}                              
  validation:  # validate `CustomResource`                          
    openAPIV3Schema:                        
      properties:                           
        spec:                               
          type: object                      
          properties:                       
            partitions:                     
              type: integer                 
              minimum: 1                    
            replicas:                       
              type: integer                 
              minimum: 1                    
              maximum: 32767                
      # ...                                 
```

TODO 2.2.2. Strimzi custom resource status

### Cluster Operator

Manages:
* Kafka (including Zookeeper, Entity Operator and Kafka Exporter)
* Kafka Connect
* Kafka Mirror Maker
* Kafka Bridge

It can deploy:
* `Topic Operator`
* `User Operator`

`Kafka` resource has a lot of [configuration options](../DeploymentConfig).  

`Cluster Operator` watches for updates of Kafka resources:
* `Kafka` for the Kafka cluster
* `KafkaConnect` for the Kafka Connect cluster
* `KafkaConnectS2I` for the Kafka Connect cluster with Source2Image support
* `KafkaMirrorMaker` for the Kafka Mirror Maker instance
* `KafkaBridge` for the Kafka Bridge instance

Cluster Operator can watch Kafka resources from:
* a single namespace (the namespace it is installed)
* multiple namespaces
* all namespaces

Resources are patched or recreated.
Resource updates may disrupt the service.  

#### Deploying the Cluster Operator to watch

Prerequisites:
* Kubernetes user account which is able to create `CustomResourceDefinitions`, `ClusterRoles` and `ClusterRoleBindings` (Role Base Access Control (RBAC), permission to create, edit, and delete these resources, `system:admin`)

```
# Note: `K8s-Namespace` could be `kafka-ns`, `strimzi-ns`, ...

$: kubectl create namespace K8s-Namespace

$: sed -i 's/namespace: .*/namespace: K8s-Namespace/' install/cluster-operator/*RoleBinding*.yaml

$: kubectl apply -f install/cluster-operator
```

```
$: kubectl delete -f install/cluster-operator
```

TODO 2.3.4., 2.3.5.

#### Deploying the Cluster Operator using Helm Chart

Prerequisites:
* Helm client installed on the local machine
* Helm has to be installed in the Kubernetes cluster (before Helm 3.x)

```
# Note: create `Cluster Operator` in `K8s-Namespace` and make it watch `K8s-Namespace`

$: helm repo add strimzi https://strimzi.io/charts/
$: helm install Release-Name strimzi/strimzi-kafka-operator -n K8s-Namespace  

$: helm list -n K8s-Namespace
$: helm uninstall Release-Name -n K8s-Namespace
```

#### Deploying the Cluster Operator from OperatorHub.io

Find Strimzi on [OperatorHub.io](https://operatorhub.io/) and follow the instructions.  

### Kafka cluster

[Kafka Exporter](../KafkaExporter), Prometheus metrics exporter, can de deployed with Kafka.  

Strimzi can deploy:
* an ephemeral Kafka: for development and testing, uses `emptyDir` volumes, data is deleted with the `Pod`
* a persistent Kafka: uses `PersistentVolumes`, `PersistentVolumeClaim` and `StorageClass` for automatic volume provisioning (e.g. Amazon EBS volumes in Amazon AWS)

Deploy templates:
* `kafka-ephemeral.yaml`
* `kafka-persistent.yaml`

```
# Note: `Kafka-Cluster` is `my-cluster` by default

apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: Kafka-Cluster  # change the name of the Kafka cluster
# ...
```

#### Deploying the Kafka cluster

Prerequisites:
* `Cluster Operator` is deployed
* to persist Kafka, you have to have `PersistentVolumes` setup

See `Kafka` [configuration options](../DeploymentConfig) for how you can deploy the cluster.  

```
# Note: rename `my-cluster` in the templates
# Note: configure `.spec.entityOperator`

$: kubectl apply -f examples/kafka/kafka-ephemeral.yaml
OR
$: kubectl apply -f examples/kafka/kafka-persistent.yaml

$: kubectl delete -f examples/kafka/kafka-XYZ.yaml
```

### Kafka Connect

TODO

### Kafka Mirror Maker

TODO

### Kafka Bridge

TODO

### Deploying example clients

Prerequisites:
* Kafka cluster

```
# Note: `Kafka-Cluster` is `my-cluster` by default
# Note: `Topic-Name` can be any name

$: kubectl run kafka-producer -ti --image=strimzi/kafka:latest-kafka-2.3.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list Kafka-Cluster-kafka-bootstrap:9092 --topic Topic-Name

$: kubectl run kafka-consumer -ti --image=strimzi/kafka:latest-kafka-2.3.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server Kafka-Cluster-kafka-bootstrap:9092 --topic Topic-Name --from-beginning
```

See [`NodePort` instructions](../../../Blog/AccessingKafka2Nodeports) for how clients external to the host machine can access Kafka.  

### Topic Operator

Manages Kafka topics:
* create
* delete
* update

You can declare a `KafkaTopic` as part of your deployment.  

You can deploy the `Topic Operator` in [standalone mode](https://strimzi.io/docs/latest/#deploying-the-topic-operator-standalone-deploying).  

Prerequisites:
* `Cluster Operator` is deployed
* `Kafka` resource exists
* `.spec.entityOperator` object exists in `Kafka`

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: Kafka-Cluster
spec:
  ...
  entityOperator:
    topicOperator: {}
    userOperator: {}
```

Deploy the Kafka cluster and with it, the `Topic Operator`.  

### User Operator

Manages Kafka users:
* authentication (identity)
* authorization (permissions)

`User Operator` assumes it is the only tool used to manage Kafka users.   

You can declare a `KafkaUser` as part of your deployment.  
User credentials will be created in a `Secret`.  

Prerequisites:
* `Cluster Operator` is deployed
* `Kafka` resource exists
* `.spec.entityOperator` object exists in `Kafka`

```
apiVersion: kafka.strimzi.io/v1beta1
kind: Kafka
metadata:
  name: Kafka-Cluster
spec:
  ...
  entityOperator:
    topicOperator: {}
    userOperator: {}
```

Deploy the Kafka cluster and with it, the `Topic Operator`.  

### Strimzi Administrators

TODO

### Container images

TODO
