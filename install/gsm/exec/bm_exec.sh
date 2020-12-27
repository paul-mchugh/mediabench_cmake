#/bin/bash

. ../../bm_inc

echo "gsm encode"

BENCH_BIN=../bin/toast
BENCH_OPT="-fpl"
BENCH_INP=../data/clinton.pcm
BENCH_OUT=
BENCH_ARG="${BENCH_OPT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)


echo "gsm decode"

BENCH_BIN=../bin/untoast
BENCH_OPT="-fpl"
BENCH_INP=../data/clinton.pcm.run.gsm
BENCH_OUT=
BENCH_ARG="${BENCH_OPT} ${BENCH_INP}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG}
	done
)
