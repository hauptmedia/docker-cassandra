#!/bin/sh

if [ -z "$LISTEN_ADDRESS" ]; then
    #if listen address is not specified get the ip address of the container
    LISTEN_ADDRESS=$(hostname --ip-address)
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

if [ -n "$dc" ] && [ -n "$rack" ]; then
    echo "dc=$dc" >$CASSANDRA_HOME/conf/cassandra-rackdc.properties
    echo "rack=$rack" >>$CASSANDRA_HOME/conf/cassandra-rackdc.properties
fi

if [ -n "$SEEDS" ]; then
    sed -i -e "s/- seeds: .*/- seeds: \"$SEEDS\"/" $CASSANDRA_HOME/conf/cassandra.yaml
fi

exec "$@"
