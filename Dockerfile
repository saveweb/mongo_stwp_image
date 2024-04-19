FROM debian:bookworm-slim


RUN set -eux; \
	apt-get update;

# apt-get install gnupg curl
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        gosu \
        hostname \
        curl \
        zstd \
        htop

# import pub key
RUN set -eux; \
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
    gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    --dearmor

# add repo
RUN set -eux; \
    echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# install mongodb
RUN set -eux; \
    apt-get update; \
    apt-get install -y mongodb-org

# clean up
RUN set -eux; \
    apt-get clean; \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc

# Create /etc/mongo/
RUN set -eux; \
    mkdir -p /etc/mongo; \
    chown mongodb:mongodb /etc/mongo

COPY --chown=root:root --chmod=0725 build/empty /etc/mongo/mongod.conf
COPY --chown=mongodb:mongodb --chmod=0400 build/empty /etc/mongo/mongo.keyfile
COPY build/start-mongo.sh /usr/bin/start-mongo.sh
    
# /var/lib/mongodb
VOLUME /var/lib/mongodb

EXPOSE 27017

CMD ["/bin/bash", "/usr/bin/start-mongo.sh"]