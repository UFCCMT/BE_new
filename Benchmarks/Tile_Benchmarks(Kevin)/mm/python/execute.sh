#! /bin/bash

sshpass -p "kcFAA888" ssh -o StrictHostKeyChecking=no cheng@tile-2.hcs.ufl.edu \
"cd /home/cheng/mm/mm_single_thread_kriging; tile-monitor --dev usb1 --resume --here --upload-tile-libs m -- ./mm_udn $1 $2"


exit 0
