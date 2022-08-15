#!/bin/bash

#MONGODB1=`ping -c 1 mongo-repl-1 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB2=`ping -c 1 mongo-repl-2 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`
#MONGODB3=`ping -c 1 mongo-repl-3 | head -1  | cut -d "(" -f 2 | cut -d ")" -f 1`

MONGODB1=mongo-repl-1
MONGODB2=mongo-repl-2
MONGODB3=mongo-repl-3

echo "**********************************************" ${MONGODB1}
echo "Waiting for startup.."
until curl http://${MONGODB1}:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 1
done

# echo curl http://${MONGODB1}:28017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
# echo "Started.."


echo SETUP.sh time now: `date +"%T" `
mongo --host ${MONGODB1}:27017 <<EOF
var cfg = {
    "_id": "rs0",
    "protocolVersion": 1,
    "version": 1,
    "members": [
        {
            "_id": 0,
            "host": "$HOST_URL:27017",
            "priority": 2
        },
        {
            "_id": 1,
            "host": "$HOST_URL:27018",
            "priority": 0
        },
        {
            "_id": 2,
            "host": "$HOST_URL:27019",
            "priority": 0
        }
    ],settings: {chainingAllowed: true}
};
rs.initiate(cfg, { force: true });
EOF

sleep 20

mongo --host ${MONGODB1}:27017 <<EOF
use $DB_NAME
db.createUser({user: '$DB_USERNAME', pwd: '$DB_PASSWORD', roles:[{ role: 'readWrite', db: '$DB_NAME' }]});
EOF
