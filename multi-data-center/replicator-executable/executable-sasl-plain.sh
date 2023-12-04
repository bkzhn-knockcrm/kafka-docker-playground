#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
source ${DIR}/../../scripts/utils.sh

if ! version_gt $TAG_BASE "5.3.99"; then
    log "Removing rest.extension.classes from properties files, otherwise getting Failed to find any class that implements interface org.apache.kafka.connect.rest.ConnectRestExtension and which name matches io.confluent.connect.replicator.monitoring.ReplicatorMonitoringExtension"
    head -n -1 replication-europe.properties > /tmp/temp.properties ; mv /tmp/temp.properties replication-europe.properties
    head -n -1 replication-us.properties > /tmp/temp.properties ; mv /tmp/temp.properties replication-us.properties
fi

${DIR}/../../environment/mdc-sasl-plain/start.sh "${PWD}/docker-compose.mdc-sasl-plain.yml"

log "Sending sales in Europe cluster"
seq -f "european_sale_%g ${RANDOM}" 10 | docker container exec -i broker-europe kafka-console-producer --broker-list localhost:9092 --topic sales_EUROPE --producer.config /etc/kafka/client.properties

log "Sending sales in US cluster"
seq -f "us_sale_%g ${RANDOM}" 10 | docker container exec -i broker-us kafka-console-producer --broker-list localhost:9092 --topic sales_US --producer.config /etc/kafka/client.properties

log "Starting replicator instances"
docker compose -f ../../environment/mdc-plaintext/docker-compose.yml -f ../../environment/mdc-sasl-plain/docker-compose.sasl-plain.yml -f docker-compose.mdc-sasl-plain.replicator.yml up -d

../../scripts/wait-for-connect-and-controlcenter.sh replicator-us $@
../../scripts/wait-for-connect-and-controlcenter.sh replicator-europe $@

sleep 120

log "Verify we have received the data in all the sales_ topics in EUROPE"
timeout 120 docker container exec broker-europe kafka-console-consumer --bootstrap-server localhost:9092 --whitelist "sales_.*" --from-beginning --max-messages 20 --property metadata.max.age.ms 30000 --consumer.config /etc/kafka/client.properties

log "Verify we have received the data in all the sales_ topics in the US"
timeout 120 docker container exec broker-us kafka-console-consumer --bootstrap-server localhost:9092 --whitelist "sales_.*" --from-beginning --max-messages 20 --property metadata.max.age.ms 30000 --consumer.config /etc/kafka/client.properties
