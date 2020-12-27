#/bin/bash

. ../../bm_inc

echo "epic encode"

BENCH_BIN=../bin/epic
BENCH_OPT="-b 25"
BENCH_INP=../data/test_image.pgm
BENCH_OUT=
BENCH_ARG="${BENCH_INP} ${BENCH_OPT} ${BENCH_OUT}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG} &>/dev/null
	done
)


echo "epic decode"

BENCH_BIN=../bin/unepic
BENCH_OPT=
BENCH_INP=../data/test.image.pgm.E
BENCH_OUT=
BENCH_ARG="${BENCH_INP} ${BENCH_OPT} ${BENCH_OUT}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG} &>/dev/null
	done
)
