#!/bin/bash

echo 'first create the folder'
for f in ./op_* ; do mkdir -p "jpg/${f%}" "mov" ; done
sleep 3s
echo 'folder successfully created'
sleep 3s
echo 'now will convert all exr to 25% JPG'
for e in op_*/*.exr; do convert "$e" -resize 25% "jpg/${e%.exr}.jpg"; done
echo 'converting done'
sleep 3s
echo 'Converting all jpgs to mov using ffmpeg'
cd jpg/ && for f in op_*; do avconv -i "$f/%04d.jpg" -vcodec copy -r 24 "../mov/$f.mov"; done
sleep 3s
cd ..
echo 'converting done, please check in mov folder'
