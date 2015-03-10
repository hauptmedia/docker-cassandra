FROM		hauptmedia/java:oracle-java7

ENV     	DEBIAN_FRONTEND noninteractive

ENV		    CASSANDRA_VERSION		2.1.3
ENV		    CASSANDRA_INSTALL_DIR	/opt/cassandra
ENV         CASSANDRA_DOWNLOAD_URL  http://www.us.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz

# install needed debian packages & clean up
RUN		apt-get update && \
		apt-get install -y --no-install-recommends curl tar ca-certificates && \
		apt-get clean autoclean && \
        apt-get autoremove --yes && \
        rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract casandra
RUN		mkdir -p ${CASSANDRA_INSTALL_DIR} && \
		curl -L --silent ${CASSANDRA_DOWNLOAD_URL} | tar -xz --strip=1 -C ${CASSANDRA_INSTALL_DIR}

WORKDIR ${CASSANDRA_INSTALL_DIR}

# Cassandra inter-node ports
# 7000 Cassandra inter-node cluster communication.
# 7001 Cassandra SSL inter-node cluster communication.
# 7199 Cassandra JMX monitoring port.

# Cassandra client ports
# 9042 Cassandra client port.
# 9169 Cassandra client port (Thrift).

EXPOSE 7000 7001 7199 9042 9160

COPY	docker-entrypoint.sh	/usr/local/sbin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh"]

CMD ["bin/cassandra", "-f"]