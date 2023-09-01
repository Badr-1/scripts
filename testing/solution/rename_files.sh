#!/bin/bash
c=1
for i in ./*.$1; do
    mv $i $2$c.$1
    c=$(($c + 1))
done
