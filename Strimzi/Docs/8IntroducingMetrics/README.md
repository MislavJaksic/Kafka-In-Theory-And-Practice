## [Introducing Metrics](https://strimzi.io/docs/latest/#assembly-metrics-setup-str)

Monitor Strimzi Kafka, ZooKeeper and Kafka Connect with Prometheus and Grafana.  

You can also use [Kafka Exporter](../10KafkaExporter).  

### Example Metrics files

You can find lots of examples in the `Strimzi release artefacts`.  

### Prometheus metrics

Strimzi uses the `Prometheus JMX Exporter`.  

To expose metrics, edit the `Kafka` resource. See `Research`.  

### Prometheus

Uses the CoreOS Prometheus Operator to manage Prometheus server.  
Deploy:
* the Prometheus Operator
* the Prometheus server

```
$: curl -s https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/rbac/prometheus-operator/prometheus-operator-deployment.yaml | sed -e 's/namespace: .*/namespace: K8s-Namespace/' > prometheus-operator-deployment.yaml
$: curl -s https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/rbac/prometheus-operator/prometheus-operator-cluster-role.yaml > prometheus-operator-cluster-role.yaml
$: curl -s https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/rbac/prometheus-operator/prometheus-operator-cluster-role-binding.yaml | sed -e 's/namespace: .*/namespace: K8s-Namespace/' > prometheus-operator-cluster-role-binding.yaml
$: curl -s https://raw.githubusercontent.com/coreos/prometheus-operator/master/example/rbac/prometheus-operator/prometheus-operator-service-account.yaml | sed -e 's/namespace: .*/namespace: K8s-Namespace/' > prometheus-operator-service-account.yaml

$: kubectl apply -f prometheus-operator-deployment.yaml
$: kubectl apply -f prometheus-operator-cluster-role.yaml
$: kubectl apply -f prometheus-operator-cluster-role-binding.yaml
$: kubectl apply -f prometheus-operator-service-account.yaml
```

```
$: sed -i 's/namespace: .*/namespace: K8s-Namespace/' prometheus.yaml  # see Research

# Note: edit strimzi-service-monitor.yaml namespace selector  # see Research

3. ??? required step?

4. does nothing - there is not namespace to replace

$: kubectl apply -f strimzi-service-monitor.yaml
$: kubectl apply -f prometheus-rules.yaml
$: kubectl apply -f prometheus.yaml
```

### Prometheus Alertmanager

TODO

### Grafana

Grafana provides visualizations of Prometheus metrics.

You can deploy and enable the example Grafana dashboards provided with Strimzi.
8.5.1. Grafana configuration

Strimzi provides example dashboard configuration files for Grafana.

A Grafana docker image is provided for deployment:

    grafana.yaml

Example dashboards are also provided as JSON files:

    strimzi-kafka.json

    strimzi-kafka-connect.json

    strimzi-zookeeper.json

The example dashboards are a good starting point for monitoring key metrics, but they do not represent all available metrics. You may need to modify the example dashboards or add other metrics, depending on your infrastructure.

For Grafana to present the dashboards, use the configuration files to:

    Deploy Grafana

8.5.2. Deploying Grafana

To deploy Grafana to provide visualizations of Prometheus metrics, apply the example configuration file.
Prerequisites

    Metrics are configured for the Kafka cluster resource

    Prometheus and Prometheus Alertmanager are deployed

Procedure

    Deploy Grafana:

    kubectl apply -f grafana.yaml

    Enable the Grafana dashboards.

8.5.3. Enabling the example Grafana dashboards

Set up a Prometheus data source and example dashboards to enable Grafana for monitoring.
Note
	No alert notification rules are defined.

When accessing a dashboard, you can use the port-forward command to forward traffic from the Grafana pod to the host.

For example, you can access the Grafana user interface by:

    Running kubectl port-forward grafana-1-fbl7s 3000:3000

    Pointing a browser to http://localhost:3000

Note
	The name of the Grafana pod is different for each user.
Procedure

    Access the Grafana user interface using admin/admin credentials.

    On the initial view choose to reset the password.
    Grafana login

    Click the Add data source button.
    Grafana home

    Add Prometheus as a data source.

        Specify a name

        Add Prometheus as the type

        Specify the connection string to the Prometheus server (http://prometheus-operated:9090) in the URL field

    Click Add to test the connection to the data source.
    Add Prometheus data source

    Click Dashboards, then Import to open the Import Dashboard window and import the example dashboards (or paste the JSON).
    Add Grafana dashboard

After importing the dashboards, the Grafana dashboard homepage presents Kafka and ZooKeeper dashboards.

When the Prometheus server has been collecting metrics for a Strimzi cluster for some time, the dashboards are populated.
Kafka dashboard
Kafka dashboardKafka dashboard
ZooKeeper dashboard
ZooKeeper dashboardZooKeeper dashboard
8.6. Using metrics with minikube or minishift

When adding Prometheus and Grafana servers to an Apache Kafka deployment using minikube or minishift, the memory available to the virtual machine should be increased (to 4 GB of RAM, for example, instead of the default 2 GB).

For information on how to increase the default amount of memory, see:

    Installing a Kubernetes cluster

    Installing an OpenShift cluster.

Additional resources

    Prometheus - Monitoring Docker Container Metrics using cAdvisor describes how to use cAdvisor (short for container Advisor) metrics with Prometheus to analyze and expose resource usage (CPU, Memory, and Disk) and performance data from running containers within pods on Kubernetes.
