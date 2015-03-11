# docker-cassandra

Run cassandra in a docker container

## Exposed ports

### Cassandra inter-node ports
* TCP   7000   Cassandra inter-node cluster communication.
* TCP   7001   Cassandra SSL inter-node cluster communication.
* TCP   7199   Cassandra JMX monitoring port.

### Cassandra client ports
* TCP   9042   Cassandra client port.
* TCP   9169   Cassandra client port (Thrift).

## Example

```bash
docker run -d \
-e SEEDS=<ip1>,<ip2>,<ip3> \
-e CLUSTER_NAME=MyCluster \
-e ENDPOINT_SNITCH=GossipingPropertyFileSnitch \
-e DC=DC1 \
-e RACK=RACK1 \
-v /path/to/spindle1:/opt/cassandra/data \
-v /path/to/spindle2:/opt/cassandra/data/commitlog \
hauptmedia/cassandra
```
