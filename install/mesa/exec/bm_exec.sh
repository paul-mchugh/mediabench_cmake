#/bin/bash

. ../../bm_inc

echo "mesa render"

time (
	for i in $ITERS;
	do
		../bin/mipmap > out1
		../bin/osdemo > out2
		../bin/texgen > out3
	done
)
