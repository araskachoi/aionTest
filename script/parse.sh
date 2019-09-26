#!/bin/bash -xeu

folderPath="/home/master/daniel/saturation/series"

echo "parsing"

for i in $(seq 9); do
	echo $folderPath$i
	python3 ./main.py $folderPath$i
done

