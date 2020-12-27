#/bin/bash

. ../../bm_inc

echo "mpeg2 encode"

NAME=mpeg2encode
BENCH_BIN=../bin/${NAME}
BENCH_OPT="../data/options.par"
BENCH_INP="../data/out.m2v"
BENCH_OUT=
BENCH_ARG="${BENCH_OPT} ${BENCH_INP} ${BENCH_OUT}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG} &>/dev/null
	done
)


echo "mpeg2 decode"

NAME=mpeg2decode
BENCH_BIN=../bin/${NAME}
BENCH_OPT="-r -f -o0"
BENCH_INP="-b ../data/mei16v2.m2v"
BENCH_OUT="../data/tmp%d"
BENCH_ARG="${BENCH_INP} ${BENCH_OPT} ${BENCH_OUT}"

time (
	for i in $ITERS;
	do
		${BENCH_BIN} ${BENCH_ARG} &>/dev/null
	done
)
