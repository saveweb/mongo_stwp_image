#!/bin/bash

set -eux;

# db and config
touch /etc/mongo/mongod.conf
touch /etc/mongo/mongo.keyfile

# if /etc/mongo/mongod.conf is empty, exit
if [ ! -s /etc/mongo/mongod.conf ]; then
  echo "/etc/mongo/mongod.conf is empty, please edit it. Exiting.";
  exit 1;
fi

chown -R mongodb:mongodb /var/lib/mongodb;
chown root:root /etc/mongo/mongod.conf;
chmod 0644 /etc/mongo/mongod.conf;

# keyfile
if [ -f /etc/mongo/mongo.keyfile ]; then
  chown mongodb:mongodb /etc/mongo/mongo.keyfile;
  chmod 0400 /etc/mongo/mongo.keyfile;
fi

echo "Hostname: $(hostname)";
# start as mongodb user
echo "Starting mongodb";
exec gosu mongodb mongod --config /etc/mongo/mongod.conf;