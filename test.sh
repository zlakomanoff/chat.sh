#!/bin/bash
count=$(ls fifos/*.fifo | wc -l)
for pi in fifos/*.fifo
do
	echo $count
	echo $pi
done
