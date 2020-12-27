#!/bin/bash

#set remote execution lock
echo 1 > ~/rem_exe_lock

#configuration info
mediabenchDir=~/mediabench
unpackDir=$mediabenchDir/unpack
resultDir=$mediabenchDir/result

#Arguments are $1=packname $2=iterCount

#marshal the arguments
if [ -z "$1" ];
then
    echo "Fatal error no name for exepack" | tee -a $resultFile
    exit 1
fi
packname=$1
iterCount=${2:-1000}
resultFile="$resultDir/result_$packname.txt"

#make sure we are in mediabench dir
cd $mediabenchDir

#setup the runcom and itercount
export ITER_OVERRIDE=$iterCount
runcom="./bm_exec.sh"

#make sure we have a reuslt dir and nothing that conflicts with out result file
mkdir -p $resultDir
rm -rf $resultFile

#unpack the exefiles
#first makesure we have nothing there that could get in out way
rm -rf $unpackDir/exepack

#unpack the exepack
cd $unpackDir
tar -xzf $packname
cd $mediabenchDir

#exepacks are structured as follows
#  +unpack/
#  |
#  +-exepack10-16-2020.tar.gz
#  +-exepack10-25-2020.tar.gz
#  +-...
#  +--+exepack/
#     |
#     +--+aco/
#     |  |
#     |  +--+adpcm/bin/
#     |  |  |
#     |  |  +-rawcaudio
#     |  |  +-rawdaudio
#     |  |
#     |  +--+epic/bin/
#     |     |
#     |     +-epic
#     |     +-unepic
#     |
#     +--+bb/
#        |
#        +--+adpcm/bin
#        |  |
#        |  +-rawcaudio
#        |  +-rawdaudio
#        |
#        +--+epic/bin/
#           |
#           +-epic
#           +-unepic

#iterate over each profile in the dir
for profile in $unpackDir/exepack/*;
do
    #report profile executions
    echo "Executing benchmarks in $profile" | tee -a $resultFile

    #copy the executables to their bin dirs
    for exe in $(file $profile/*/bin/*| grep -E ":.*aarch64"|cut -d: -f1|uniq);
    do
        exepath=${exe#"$profile/"}
        cp $profile/$exepath $mediabenchDir/$exepath
    done

    #run the benchmarks
    $runcom  2>&1 | tee -a $resultFile
done

#report completion
echo "Done executing all benchmarks" | tee -a $resultFile

#clear remote execution lock
echo 0 > ~/rem_exe_lock
