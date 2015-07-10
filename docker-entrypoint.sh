#!/bin/sh

CONTAINER_IP=$(hostname --ip-address)

if [ -z "$LISTEN_ADDRESS" ]; then
    #if listen address is not specified get the ip address of the container
    LISTEN_ADDRESS=${CONTAINER_IP}
fi

if [ -z "$SEEDS" ]; then
    SEEDS=${CONTAINER_IP}
fi

sed -i -e "s/listen_address: .*/listen_address: $LISTEN_ADDRESS/"                   $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e "s/rpc_address: .*/rpc_address: 0.0.0.0/"                                 $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e "s/# broadcast_address.*/broadcast_address: $LISTEN_ADDRESS/"             $CASSANDRA_HOME/conf/cassandra.yaml
sed -i -e "s/# broadcast_rpc_address.*/broadcast_rpc_address: $LISTEN_ADDRESS/"     $CASSANDRA_HOME/conf/cassandra.yaml

if [ -n "$CLUSTER_NAME" ]; then
    sed -i -e "s/cluster_name: .*/cluster_name: '$CLUSTER_NAME'/" $CASSANDRA_HOME/conf/cassandra.yaml
fi

if [ -n "$ENDPOINT_SNITCH" ]; then
    sed -i -e "s/endpoint_snitch: .*/endpoint_snitch: $ENDPOINT_SNITCH/" $CASSANDRA_HOME/conf/cassandra.yaml
fi

if [ -n "$DC" ] && [ -n "$RACK" ]; then
    echo "dc=$DC" >$CASSANDRA_HOME/conf/cassandra-rackdc.properties
    echo "rack=$RACK" >>$CASSANDRA_HOME/conf/cassandra-rackdc.properties
fi

sed -i -e "s/- seeds: .*/- seeds: \"$SEEDS\"/" $CASSANDRA_HOME/conf/cassandra.yaml

if [ -z "$OPS_IP" ]; then
	rm /etc/supervisor/conf.d/datastax-agent.conf
else 
	/opt/datastax-agent/bin/setup ${OPS_IP}
fi


exec "$@"
