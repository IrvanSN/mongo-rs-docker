#!/bin/bash

#MONGODB1=`ping -c 1 mongo-repl-1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB2=`ping -c 1 mongo-repl-2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB3=`ping -c 1 mongo-repl-3 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

MONGODB1=mongo-repl-1

VAR_HOST_URL=$(cat run/secrets/host-url)
VAR_DB_NAME=$(cat run/secrets/mongo-name)
VAR_DB_USERNAME=$(cat run/secrets/mongo-username)
VAR_DB_PASSWORD=$(cat run/secrets/mongo-password)

echo "Waiting for startup.."
until curl http://${MONGODB1}:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

# echo curl http://${MONGODB1}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
# echo "Started.."

mongo --host ${MONGODB1}:27017 <<EOF
var cfg = {
    "_id": "rs0",
    "protocolVersion": 1,
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": \"${VAR_HOST_URL}:27017\",
            "priority": 2
        },
        {
            "_id": 1,
            "host": \"${VAR_HOST_URL}:27018\",
            "priority": 0
        },
        {
            "_id": 2,
            "host": \"${VAR_HOST_URL}:27019\",
            "priority": 0
        }
    ],settings: {chainingAllowed: true}
};
rs.initiate(cfg, { force: true });
EOF

sleep 20

mongo --host ${MONGODB1}:27017 <<EOF
use $VAR_DB_NAME
db.createUser({user: \"${VAR_DB_USERNAME}\", pwd: \"${VAR_DB_PASSWORD}\", roles:[{ role: "readWrite", db: \"${VAR_DB_NAME}\" }]});
EOF
