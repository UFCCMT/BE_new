#! /bin/bash

sshpass -p "KCheng888" ssh -o StrictHostKeyChecking=no cheng@power.hcs.ufl.edu \
"cd /home/cheng/mm; ./mm_udn $1 $2"


exit 0