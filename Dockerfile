FROM royseto/pgbuild

# This Dockerfile starts a running PostgreSQL server on port 6543. It creates a
# data volume at /mnt/data/pgsql that contains a basic empty database cluster
# configured for testing but not production (small memory parameters, NOT
# SECURE). This image can also mount a production database disk at
# /mnt/data/pgsql that contains suitable production settings.

# Some parts copied from https://github.com/docker-library/postgres/blob/master/Dockerfile.template

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y --auto-remove ca-certificates wget

# Point to our postgres install.
ENV LD_LIBRARY_PATH /usr/local/pgsql/lib
ENV PATH /usr/local/pgsql/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

COPY . /setup
RUN /bin/cp /setup/docker-entrypoint.sh /docker-entrypoint.sh \
  && /bin/chmod 755 /docker-entrypoint.sh

VOLUME ["/mnt/data/pgsql"]
EXPOSE 6543

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["postgres"]

