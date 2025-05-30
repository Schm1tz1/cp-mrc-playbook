# Zookeeper-based MRC and multi-DC setups
This directory contains 3 stretch cluster setups:
* 2 DC Kafka Cluster
* 2.5 DC AOP Kafka Cluster (non-MRC and MRC)
* 3 DC Kafka Cluster

## Namespaced Operator Deployments
For the 3DC and 2.5DC setup you need 3 namespaces, for 2DC you need 2 namespaces:
```shell
# Required for all deployments
kubectl create namespace dc1
helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --set namespaced=true \
  --namespace dc1

# Required for all deployments
kubectl create namespace dc2
helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --set namespaced=true \
  --namespace dc2

# Required for 3 DC and 2.5 DC
kubectl create namespace dc3
helm upgrade --install confluent-operator \
  confluentinc/confluent-for-kubernetes \
  --set namespaced=true \
  --namespace dc3  
```