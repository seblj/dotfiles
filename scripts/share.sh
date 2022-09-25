#!/bin/bash

if [ -z "$1" ]; then
    echo Specify a server and folder
    exit 1
fi

rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

fswatch -r0 -Ie $PWD/4913 --event Created --event Updated --event Removed -0 $PWD | while read -d "" event; do

	rsync -avz -q -e "ssh" $PWD $1 &>/dev/null

done &

