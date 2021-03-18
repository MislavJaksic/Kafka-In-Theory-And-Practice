## [kowl](https://github.com/cloudhut/kowl)  

kowl is a Apache Kafka Web UI for exploring messages, consumers nd configurations.  

### Install

Their installation instructions are lacking.  

#### [Helm](https://github.com/cloudhut/charts)

```
$: helm repo add cloudhut https://raw.githubusercontent.com/cloudhut/charts/master/archives
$: helm repo update

$: helm install -f values.yaml kowl cloudhut/kowl  # see Research
```

```
http://Kafka-Broker-Ip-Port:kowl-assigned-nodeport
```
