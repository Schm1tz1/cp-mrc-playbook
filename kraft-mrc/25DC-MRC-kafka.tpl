---
apiVersion: platform.confluent.io/v1beta1
kind: Kafka
metadata:
  name: kafka-##RACK##
  namespace: ##DC##
  annotations:
    platform.confluent.io/broker-id-offset: "##OFFSET##"
spec:
  replicas: 1
  oneReplicaPerNode: true
  image:
    application: confluentinc/cp-server:7.9.1
    init: confluentinc/confluent-init-container:2.11.1
  dataVolumeCapacity: 10Gi
  podTemplate:
    resources:
      requests:
        cpu: 200m
        memory: 512Mi
    podSecurityContext:
      fsGroup: 1000
      runAsUser: 1000
      runAsNonRoot: true
  dependencies:
    kRaftController:
      clusterRef:
        name: kraftcontroller
        namespace: ##DC##
  mountedVolumes:
    volumes:
      - name: placements
        configMap:
          name: replica-placement
    volumeMounts:
      - name: placements
        mountPath: /mnt/placements
        readOnly: true
  configOverrides:
    server:
      - confluent.consumer.lag.emitter.enabled=true
      - confluent.consumer.lag.emitter.interval.ms=10000
      - broker.rack=##RACK##
      - config.providers=file,dir,env
      - config.providers.dir.class=org.apache.kafka.common.config.provider.DirectoryConfigProvider
      - config.providers.env.class=org.apache.kafka.common.config.provider.EnvVarConfigProvider
      - config.providers.file.class=org.apache.kafka.common.config.provider.FileConfigProvider
      - confluent.metadata.topic.replication.factor=6
      - confluent.metadata.topic.min.insync.replicas=3
      - confluent.balancer.topic.replication.factor=6
      - confluent.security.event.logger.exporter.kafka.topic.replicas=6
      - default.replication.factor=6
      - min.insync.replicas=3
      - offsets.topic.replication.factor=6
      - offsets.topic.min.isr=3
      - transaction.state.log.replication.factor=6
      - transaction.state.log.min.isr=3
      - replica.selector.class=org.apache.kafka.common.replica.RackAwareReplicaSelector
      - confluent.link.metadata.topic.replication.factor=6
      - confluent.link.metadata.topic.min.isr=3
      - confluent.license.topic.replication.factor=6
      - confluent.license.topic.min.isr=3
      - confluent.cluster.link.metadata.topic.replication.factor=6
      - confluent.cluster.link.metadata.topic.min.isr=3
      - confluent.log.placement.constraints=${dir:/mnt/placements:2dc-mrc-observers.json}
      - confluent.offsets.topic.placement.constraints=${dir:/mnt/placements:2dc-mrc-observers.json}
      - confluent.transaction.state.log.placement.constraints=${dir:/mnt/placements:2dc-mrc-observers.json}
  