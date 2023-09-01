#!/bin/bash
if [[ -e $2/$1 ]]; then
    echo "File exists"
    echo "contents of $1: "
    cat $2/$1
else
    echo "File does not exist "
fi
