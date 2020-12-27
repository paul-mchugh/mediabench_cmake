#/bin/bash

. ../../bm_inc

echo "jpeg encode"

BENCH_BIN=../bin/cjpeg
BENCH_OPT="-dct int -progressive -opt"
BENCH_INP=../data/testimg.ppm
BENCH_OUT="-outfile ../data/testout.jpeg"
BENCH_ARG="${BENCH_OPT} ${BENCH_OUT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)


echo "jpeg decode"

NAME=djpeg
BENCH_BIN=../bin/${NAME}
BENCH_OPT="-dct int -ppm"
BENCH_INP=../data/testimg.jpg
BENCH_OUT="-outfile ../data/testout.ppm"
BENCH_ARG="${BENCH_OPT} ${BENCH_OUT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)
