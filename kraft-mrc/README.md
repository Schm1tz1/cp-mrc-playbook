# CP Stretch Cluster Setups with KRaft
This Gist contains 3 stretch cluster setups:
* 2 DC Kafka Cluster with KRaft
* 2.5 DC AOP Kafka Cluster with KRaft (non-MRC and MRC)
* 3 DC Kafka Cluster with KRaft

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

## Deploy Controllers
### 2 DC Deployment
#### KRaft Controllers
* Start with first KRaft controller and retrieve ClusterID:
```shell
kubectl apply -f 2DC-kraft-dc1.yaml
CLUSTER_ID=$(kubectl get kraftcontroller kraftcontroller \
  --namespace dc1 \
  -ojson | jq -r .status.clusterID)
```
* Replace ClusterID in YAML for other DC and deploy:
```shell
cat 2DC-kraft-dc2.tpl | sed "s/CLUSTER_ID/${CLUSTER_ID}/g" | kubectl apply -f -
```
* Alternatively (fixed ClusterId):
```shell
kubectl apply -f 2DC-kraft-all.yaml
```

#### Deploy Brokers
```shell
kubectl apply -f 2DC-kafka.yaml
```

### 2.5 DC Deployment
#### Simplified Deployment Script
```shell
./25DC-deploy.sh
```

#### Deploy Replica Placements
```shell
kubectl apply -f 25DC-placement.yaml -n dc1
kubectl apply -f 25DC-placement.yaml -n dc2
kubectl apply -f 25DC-placement.yaml -n dc3
```

#### KRaft Controllers
* Start with first KRaft controller and retrieve ClusterID:
```shell
kubectl apply -f 25DC-kraft-dc1.yaml
CLUSTER_ID=$(kubectl get kraftcontroller kraftcontroller \
  --namespace dc1 \
  -ojson | jq -r .status.clusterID)
```
* Replace ClusterID in YAML for other DCs and deploy:
```shell
cat 25DC-kraft-dc2-dc3.tpl | sed "s/CLUSTER_ID/${CLUSTER_ID}/g" | kubectl apply -f -
```
* Alternatively (fixed ClusterId):
```shell
kubectl apply -f 25DC-kraft-all.yaml
```

#### Deploy Brokers
```shell
kubectl apply -f 25DC-kafka.yaml
```

### 3 DC Deployment


## Check / Investigate KRaft Cluster
* Get cluster status:
```shell
kubectl exec -it kafka-0 -n dc1 -- bash -c "kafka-metadata-quorum --bootstrap-server localhost:9092 describe --status"
```

Example:
```shell
[appuser@kraftcontroller-0 ~]$ kafka-metadata-quorum --bootstrap-controller localhost:9074 describe --status
ClusterId:              ZjczNWY5ZjItZTA3OS00Nw
LeaderId:               920
LeaderEpoch:            19
HighWatermark:          3457
MaxFollowerLag:         0
MaxFollowerLagTimeMs:   372
CurrentVoters:          [{"id": 930, "directoryId": null, "endpoints": ["CONTROLLER://kraftcontroller-0-internal.dc3:9074"]}, {"id": 920, "directoryId": null, "endpoints": ["CONTROLLER://kraftcontroller-0-internal.dc2:9074"]}, {"id": 910, "directoryId": null, "endpoints": ["CONTROLLER://kraftcontroller-0-internal.dc1:9074"]}]
CurrentObservers:       [{"id": 201, "directoryId": "blibcKjWRy70gataLy2kaw"}, {"id": 100, "directoryId": "Om2-8Pcj64GQ2vET895bUw"}, {"id": 101, "directoryId": "1jwV9ExUvoQMpmL_gx5gRQ"}, {"id": 102, "directoryId": "PBCAcfUbWNE_PXZQIuBvsQ"}, {"id": 202, "directoryId": "2uecqGmnY2qeZ2D7B9C-Wg"}, {"id": 200, "directoryId": "Km9q-GMkL5q0aE1BjtsVHg"}]
```
* Get roles and replication status:
```shell
kubectl exec -it kafka-0 -n dc1 -- bash -c "kafka-metadata-quorum --bootstrap-server localhost:9092 describe --replication"
```

Example:
```shell
[appuser@kraftcontroller-0 ~]$ kafka-metadata-quorum --bootstrap-controller localhost:9074 describe --replication
NodeId  DirectoryId             LogEndOffset    Lag     LastFetchTimestamp      LastCaughtUpTimestamp   Status
920     AAAAAAAAAAAAAAAAAAAAAA  3568            0       1743503537096           1743503537096           Leader
930     AAAAAAAAAAAAAAAAAAAAAA  3568            0       1743503536947           1743503536947           Follower
910     AAAAAAAAAAAAAAAAAAAAAA  3568            0       1743503536948           1743503536948           Follower
201     blibcKjWRy70gataLy2kaw  3568            0       1743503536943           1743503536943           Observer
100     Om2-8Pcj64GQ2vET895bUw  3568            0       1743503536947           1743503536947           Observer
101     1jwV9ExUvoQMpmL_gx5gRQ  3568            0       1743503536943           1743503536943           Observer
102     PBCAcfUbWNE_PXZQIuBvsQ  3568            0       1743503536948           1743503536948           Observer
202     2uecqGmnY2qeZ2D7B9C-Wg  3568            0       1743503536943           1743503536943           Observer
200     Km9q-GMkL5q0aE1BjtsVHg  3568            0       1743503536943           1743503536943           Observer
```

* Open metadata shell:
```shell
kubectl exec -it kraftcontroller-0 -n dc1 -- bash -c "kafka-metadata-shell --directory /mnt/data/data0/logs/__cluster_metadata-0"
```

Example:
```shell
[appuser@kraftcontroller-0 ~]$ kafka-metadata-shell --directory /mnt/data/data0/logs/__cluster_metadata-0
[2025-03-20 11:21:45,092] WARN Found invalid messages in log segment /mnt/data/data0/logs/__cluster_metadata-0/00000000000000000000.log at byte offset 61062: Record is corrupt (crc could not be retrieved as the record is too small, size = 0). null (org.apache.kafka.storage.internals.log.LogSegment)
[2025-03-20 11:21:45,099] WARN [LogLoader partition=__cluster_metadata-0, dir=/mnt/data/data0/logs] Corruption found in segment 0, truncating to offset 843 (kafka.log.LogLoader)
Loading...
Starting...
[ Kafka Metadata Shell ]
>> ls /image/cluster/controllers/
910  911  920
>> cat /image/cluster/controllers/910
ControllerRegistration(id=910, incarnationId=xWblwlegRrSCxMzUNsOucw, zkMigrationReady=false, listeners=[Endpoint(listenerName='CONTROLLER', securityProtocol=PLAINTEXT, host='kraftcontroller-0.kraftcontroller.dc1.svc.cluster.local', port=9074)], supportedFeatures={confluent.metadata.version: 1-120, metadata.version: 1-20}, metadataEncryptors=[])
>>
```

## Check Partition Assignments
### Collect Configurations
* Rack Settings:
```shell
kubectl exec -it kafka-0 -n dc1 -- kafka-broker-api-versions --bootstrap-server kafka:9092 | grep rack
```
Example output:
```
kafka-1.kafka.dc1.svc.cluster.local:9092 (id: 101 rack: dc1) -> (
kafka-0.kafka.dc2.svc.cluster.local:9092 (id: 200 rack: dc2) -> (
kafka-1.kafka.dc2.svc.cluster.local:9092 (id: 201 rack: dc2) -> (
kafka-0.kafka.dc1.svc.cluster.local:9092 (id: 100 rack: dc1) -> (
```
* Placement Constraints (per Broker Id) - only relevant for 2.5DC due to observer placements:
```shell
kubectl exec -it kafka-0 -n dc1 -- kafka-configs --describe --bootstrap-server kafka:9092 \
--broker 100 --all | grep placement.constraints
```
### Test replication settings and constraints
* Create and describe:
```shell
kubectl exec -it kafka-0 -n dc1 -- kafka-topics --bootstrap-server kafka:9092 \
--create --topic test
kubectl exec -it kafka-0 -n dc1 -- kafka-topics --bootstrap-server kafka:9092 \
--describe --topic test
```

Example output (with observers):
```
Topic: test     TopicId: Qdrp6ouBTIOcIw0bnDqVOA PartitionCount: 1       ReplicationFactor: 6    Configs: min.insync.replicas=3,segment.bytes=1073741824,message.format.version=3.0-IV1,confluent.placement.constraints={"observerPromotionPolicy":"under-min-isr","version":2,"replicas":[{"count":2,"constraints":{"rack":"dc1"}},{"count":2,"constraints":{"rack":"dc2"}}],"observers":[{"count":1,"constraints":{"rack":"dc1"}},{"count":1,"constraints":{"rack":"dc2"}}]}
        Topic: test     Partition: 0    Leader: 101     Replicas: 101,102,202,200,100,201       Isr: 101,102,202,200    Offline:     Observers: 100,201       Elr: N/A        LastKnownElr: N/A
```

* Clean up:
```shell
kubectl exec -it kafka-0 -n dc1 -- kafka-topics --bootstrap-server kafka:9092 \
--delete --topic test
```

### Enforcing constraints
* Enforce configured constraints that have not been applied to (e.g. existing) topics:
```shell
kubectl exec -it kafka-0 -n dc1 -- confluent-rebalancer execute --bootstrap-server kafka:9092 --topics {topic-name} \
--replica-placement-only --throttle 1000000
```

## Testing

### 2.5 DC
* Produce random data:
```shell
kubectl exec kcat -it -- bash -c "cat /dev/urandom | \
  tr -dc 'a-zA-Z0-9' | fold -w 128 | \
  kcat -b kafka.dc1:9092 -t test -P"
```