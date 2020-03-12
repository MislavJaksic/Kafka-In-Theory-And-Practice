## [2. Getting started with Strimzi](https://strimzi.io/docs/latest/#getting-started-str)

Strimzi benefits from integration with `OpenShift` (Kubernetes distribution).  

The guide assumes `kubectl` can reach `Kubernetes`.  

### 2.1. Installing Strimzi and deploying components

[Strimzi release artefacts](https://github.com/strimzi/strimzi-kafka-operator/releases), YAML files, are referenced throughout the docs.  
`Cluster Operator` can be deployed using a `Helm` chart.  

### 2.2. Custom resources

`CustomResourceDefinition`s (`CRD`s) extend the `Kubernetes` API.  
`CustomResource`s are instances of `CRD`s.  
`CRD`s and `CustomResource`s are defined as YAML files.  

`CRD`s require a one-time installation in a cluster.  
A `CRD` defines a new `kind` of resource, such as `kind:Kafka` or `kind: KafkaTopic`.  

`status` property of a Strimzi `CRD` publishes information about the resource.  
See [Checking the status of a `CRD`](../15CheckingResourceStatus).  

### 2.3. Cluster Operator

Manages:
* `Kafka` (including `Zookeeper`, `Entity Operator` and `Kafka Exporter`)
* `Kafka Connect`
* `Kafka Mirror Maker`
* `Kafka Bridge`

It can deploy:
* `Topic Operator`
* `User Operator`

`Kafka` resource has a lot of [configuration options](../DeploymentConfig).  

`Cluster Operator` watches for updates of `Kafka` resources:
* `Kafka` for the `Kafka` cluster
* `KafkaConnect` for the `Kafka Connect` cluster
* `KafkaConnectS2I` for the `Kafka Connect` cluster with `Source2Image` support
* `KafkaMirrorMaker` for the Kafka Mirror Maker instance
* `KafkaBridge` for the Kafka Bridge instance

`Cluster Operator` can watch `Kafka` resources from:
* a single namespace (the namespace it is installed)
* multiple namespaces
* all namespaces

Resources are patched or recreated.  
Resource updates may disrupt the service.  

#### 2.3.3. Deploying the Cluster Operator to watch a single namespace

Prerequisites:
* Kubernetes user account which is able to create `CustomResourceDefinitions`, `ClusterRoles` and `ClusterRoleBindings` (Role Base Access Control (RBAC), permission to create, edit, and delete these resources, `system:admin`)

```
# Note: `K8s-Strimzi-Namespace` could be `kafka-ns`, `strimzi-ns`, ...

$: kubectl create namespace K8s-Strimzi-Namespace

$: sed -i 's/namespace: .*/namespace: K8s-Strimzi-Namespace/' install/cluster-operator/*RoleBinding*.yaml

$: kubectl apply -f install/cluster-operator
```

```
$: kubectl delete -f install/cluster-operator
```

You can also watch multiple or even all namespaces.  

#### 2.3.6. Deploying the Cluster Operator using Helm Chart

Prerequisites:
* Helm client installed on the local machine
* Helm has to be installed in the Kubernetes cluster (before Helm 3.x)

```
# Note: create `Cluster Operator` in `K8s-Strimzi-Namespace` and make it watch `K8s-Strimzi-Namespace`

$: helm repo add strimzi https://strimzi.io/charts/
$: helm install Release-Name strimzi/strimzi-kafka-operator -n K8s-Strimzi-Namespace  

$: helm list -n K8s-Strimzi-Namespace
$: helm uninstall Release-Name -n K8s-Strimzi-Namespace
```

#### 2.3.7. Deploying the Cluster Operator from OperatorHub.io

Find Strimzi on [OperatorHub.io](https://operatorhub.io/) and follow the instructions.  

### 2.4. Kafka cluster

[Kafka Exporter](../KafkaExporter), `Prometheus` metrics exporter, can be deployed with the `Kafka` cluster.  

Strimzi can deploy:
* an ephemeral `Kafka`: for development and testing, uses `emptyDir` volumes, data is deleted with the `Pod`
* a persistent `Kafka`: uses `PersistentVolumes`, `PersistentVolumeClaim` and `StorageClass` for automatic volume provisioning (e.g. `Amazon EBS` volumes in `Amazon AWS`)

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

#### 2.4.1. Deploying the Kafka cluster

Prerequisites:
* `Cluster Operator` is deployed
* to persist `Kafka`, you have to have `PersistentVolumes` setup

See `Kafka` [configuration options](../DeploymentConfig) for how you can deploy the cluster.  

```
# Note: rename `my-cluster` in the templates
# Note: configure `.spec.entityOperator`

$: kubectl apply -f examples/kafka/kafka-ephemeral.yaml
OR
$: kubectl apply -f examples/kafka/kafka-persistent.yaml

$: kubectl delete -f examples/kafka/kafka-XYZ.yaml
```

### 2.5. Kafka Connect

TODO

### 2.6. Kafka Mirror Maker

`Mirror Maker` replicates data between Kafka clusters.  

Prerequisites:
* `Cluster Operator` is deployed

```
$: apply -f examples/kafka-mirror-maker/kafka-mirror-maker.yaml
```

### 2.7. Kafka Bridge

TODO

### 2.8. Deploying example clients

Prerequisites:
* `Kafka` cluster

```
# Note: `Kafka-Cluster` is `my-cluster` by default
# Note: `Topic-Name` can be any name

$: kubectl run kafka-producer -ti --image=strimzi/kafka:0.16.1-kafka-2.4.0 --rm=true --restart=Never -- bin/kafka-console-producer.sh --broker-list Kafka-Cluster-kafka-bootstrap:9092 --topic Topic-Name

$: kubectl run kafka-consumer -ti --image=strimzi/kafka:0.16.1-kafka-2.4.0 --rm=true --restart=Never -- bin/kafka-console-consumer.sh --bootstrap-server Kafka-Cluster-kafka-bootstrap:9092 --topic Topic-Name --from-beginning
```

See [`NodePort` instructions](../../../Blog/AccessingKafka2Nodeports) for how clients external to the host machine can access `Kafka`.  

### 2.9. Topic Operator

Manages `Kafka` topics:
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

Deploy the `Kafka` cluster and with it, the `Topic Operator`.  

### 2.10. User Operator

Manages `Kafka` users:
* authentication, authN (identity)
* authorization, authZ (permissions)

`User Operator` assumes it is the only tool used to manage `Kafka` users!  

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

Deploy the `Kafka` cluster and with it, the `Topic Operator`.  

### 2.11. Strimzi Administrators

TODO

### 2.12. Container images

TODO
