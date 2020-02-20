## [Introducing Metrics](https://strimzi.io/docs/latest/#assembly-metrics-setup-str)

Monitor Strimzi `Kafka`, `ZooKeeper` and `Kafka Connect` with [Prometheus](https://github.com/MislavJaksic/Knowledge-Repository/tree/master/Technology/DevOps/Monitoring/Prometheus) and [Grafana](https://github.com/MislavJaksic/Knowledge-Repository/tree/master/Technology/Visualize/Grafana).  

You can also use [Kafka Exporter](../10KafkaExporter).  

### Example Metrics files

You can find lots of examples in the `Strimzi release artefacts`.  

### Prometheus metrics

Strimzi uses the `Prometheus JMX Exporter`.  

To expose metrics, edit the `Kafka` resource. See `Research`.  

### Prometheus

Uses the CoreOS [`Prometheus Operator`](https://github.com/MislavJaksic/Knowledge-Repository/tree/master/Technology/DevOps/Monitoring/Prometheus/PrometheusKubernetesOperator) to manage `Prometheus Server`.  
Deploy:
* the `Prometheus Operator`
* the `Prometheus Server`

Deploy `Prometheus Operator` `RBAC` resources:
```
$: kubectl apply -f prometheus-operator-rbac.yaml  # see Research
```

Deploy `Prometheus`:
```
# Note: see Research

$: kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml

$: kubectl apply -f strimzi-service-monitor.yaml
$: kubectl apply -f prometheus-alerting-rules.yaml
$: kubectl apply -f prometheus-rbac.yaml
$: kubectl apply -f prometheus.yaml

# Note: visit http://Kubectl-Server-Ip:30900
```

### Prometheus Alertmanager

TODO

### Grafana

`Grafana` provides visualizations of `Prometheus` metrics.

```
$: kubectl apply -f grafana.yaml  # see Research
```

```
# Note: visit http://Kubectl-Server-Ip:30901/login

# Login: admin
# Password: admin

# Add Data Source -> Prometheus ->
#  URL: http://prometheus-operated:9090
# Save and Test

# Dashboards -> Import -> Copy-paste URL, ID or JSON
```
