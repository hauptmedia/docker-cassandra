#!/bin/sh

if [ -n "$SEEDS" ]; then
    sed -i -e "s/- seeds: .*/- seeds: \"$SEEDS\"/" $CASSANDRA_HOME/conf/cassandra.yaml
fi

exec "$@"
