#!/bin/bash

IT=1000;

for img_size in "320 240" "480 320" "640 480" "800 600" "1024 768" "1280 1024" "1600 1200"
do
  set -- $img_size
  echo "Starting sobel $1x$2"

  ./sobel "$1" "$2" "$IT"

done







