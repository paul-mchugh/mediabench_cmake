#/bin/bash

. ../../bm_inc

echo "adpcm encode"

BENCHMARK=../bin/rawcaudio
INPUT=../data/clinton.pcm
OUTPUT=../results/out.adpcm

time (
	for i in $ITERS;
	do
		${BENCHMARK} < ${INPUT} > ${OUTPUT} 2>/dev/null
	done
)


echo "adpcm decode"

BENCHMARK=../bin/rawdaudio
INPUT=../data/clinton.adpcm
OUTPUT=../results/out.pcm

time (
	for i in $ITERS;
	do
		${BENCHMARK} < ${INPUT} > ${OUTPUT} 2>/dev/null
	done
)
