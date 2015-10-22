FROM		hauptmedia/java:oracle-java7

ENV     	DEBIAN_FRONTEND noninteractive

ENV		CASSANDRA_VERSION	2.1.8
ENV		CASSANDRA_HOME		/opt/cassandra
ENV		CASSANDRA_DOWNLOAD_URL  http://www.us.apache.org/dist/cassandra/${CASSANDRA_VERSION}/apache-cassandra-${CASSANDRA_VERSION}-bin.tar.gz

ENV		AGENT_HOME		/opt/datastax-agent
ENV		AGENT_VERSION		5.2.1
ENV		AGENT_DOWNLOAD_URL	http://downloads.datastax.com/community/datastax-agent-${AGENT_VERSION}.tar.gz

# install needed debian packages & clean up
RUN		apt-get update && \
		apt-get install -y --no-install-recommends curl tar ca-certificates python2.7 openssl python-openssl supervisor sysstat && \
		apt-get clean autoclean && \
		apt-get autoremove --yes && \
		rm -rf /var/lib/{apt,dpkg,cache,log}/

# download and extract cassandra
RUN		mkdir -p ${CASSANDRA_HOME} && \
		curl -L --silent ${CASSANDRA_DOWNLOAD_URL} | tar -xz --strip=1 -C ${CASSANDRA_HOME}

# download and extract datastax agent
RUN		mkdir -p ${AGENT_HOME} && \
		curl -L --silent ${AGENT_DOWNLOAD_URL} | tar -xz --strip=1 -C ${AGENT_HOME}

WORKDIR ${CASSANDRA_HOME}

# Cassandra inter-node ports
# 7000 Cassandra inter-node cluster communication.
# 7001 Cassandra SSL inter-node cluster communication.
# 7199 Cassandra JMX monitoring port.

# Cassandra client ports
# 9042 Cassandra client port.
# 9169 Cassandra client port (Thrift).

EXPOSE 7000 7001 7199 9042 9160

COPY	docker-entrypoint.sh	/usr/local/sbin/docker-entrypoint.sh

ADD	supervisor/conf.d/ /etc/supervisor/conf.d/

ENTRYPOINT ["/usr/local/sbin/docker-entrypoint.sh"]

CMD ["/usr/bin/supervisord"]
