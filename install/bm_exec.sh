#!/bin/bash

for d in */exec/;
do
	(cd $d; ./bm_exec.sh)
done

