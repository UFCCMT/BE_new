#! /bin/bash

sshpass -p "KCheng888" ssh -o StrictHostKeyChecking=no cheng@power.hcs.ufl.edu \
"cd /home/cheng/dot_prod; ./dotprod $1"


exit 0