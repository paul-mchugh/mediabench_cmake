#/bin/bash

. ../../bm_inc

echo "rasta encode"

time (
	for i in $ITERS;
	do
		../bin/rasta -z -A -J -S 8000 -n 12 -f ../spix/map_weights.dat < ../spix/ex5_c1.wav > ../spix/ex5.asc
	done
)
