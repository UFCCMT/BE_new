#! /bin/bash

sshpass -p "KCheng888" ssh -o StrictHostKeyChecking=no cheng@128.227.92.82 \
"cd /home/cheng/dot_prod; ./dotprod $1"


exit 0