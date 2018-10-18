#!/bin/sh

sshpass -p "mypassword" ssh -o StrictHostKeyChecking=no myuser@my.host.thing \
"cd my/path/to/benchmark; ./benchmark $1 $2 $3 $4"
