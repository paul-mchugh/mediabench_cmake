#/bin/bash

. ../../bm_inc

echo "g721 encode"

BENCH_BIN=../bin/encode
BENCH_OPT="-4 -l -f"
BENCH_INP=../data/clinton.pcm
BENCH_OUT=
BENCH_ARG="${BENCH_OPT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)


echo "g721 decode"

BENCH_BIN=../bin/decode
BENCH_OPT="-4 -l -f"
BENCH_INP=../data/clinton.g721
BENCH_OUT=
BENCH_ARG="${BENCH_OPT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)
