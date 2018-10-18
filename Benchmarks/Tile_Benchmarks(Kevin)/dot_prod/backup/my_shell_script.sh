#! /bin/bash

sshpass -p "kcFAA888" ssh -o StrictHostKeyChecking=no cheng@tile-2.hcs.ufl.edu \
"cd /home/cheng/calibration/serial_dot; tile-monitor --dev usb1 --resume --here -- ./dot_serial $1"


exit 0
#samples/1-Param-Dot-Prod/dotprod $1 $2
