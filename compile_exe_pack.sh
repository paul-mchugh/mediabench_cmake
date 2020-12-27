#!/bin/bash

#target specific info
targetMachine="out-of-order-pi"
mediabenchDir='~/mediabench'
unpackDir="$mediabenchDir/unpack"
runcom="./runExePack.sh"

#host specific info
hostProjectDir=~/code/comp_proj_rel/mediabench_cmake
logDir=$hostProjectDir/log
buildDir=$hostProjectDir/build
installDir=$hostProjectDir/install
workDir=$hostProjectDir/work_dir
cfg_loc=$hostProjectDir/opt_sched_cfg
ini_profiles_loc=$hostProjectDir/ini_profiles
ssh_ident_file=

#options and configuration data
iterCnt="${1:-1000}"
startExec="${2:-no}"

if [ ! -z "$ssh_ident_file" ] ;
then
	ssh_id_opt="-i $ssh_ident_file"
else
	ssh_id_opt=""
fi

ini_profiles=(
	sfiaco.ini
	sfibb.ini
	sficp.ini
	sfillvm.ini
)

waitforclearremote()
{
	locked="1"
	while [ "$locked" != "0" ];
	do
		locked="$(ssh $ssh_id_opt $targetMachine cat rem_exe_lock)"
		if [ "$locked" != "0" ];
		then
		echo Waiting for runs on $targetMachine to finish
		sleep 30
	fi
	done
}

#get list of executable dirs
cd $installDir
bmdirs=$(file */bin/* | grep -E ":.*aarch64"|cut -d: -f1| sed 's/\/[^/]*$//'|uniq|xargs)
echo "Executables list:$bmdirs"

#switch to CMake-able benchmark dir
cd $hostProjectDir

#clear old stuff in the work dir
rm -rf $workDir/exepack
mkdir -p $workDir/exepack

#make the logs dir
mkdir -p $logDir

#get the name of the resulting exepack(needs to be done now since we want the time before compiling started)
packname=$(date "+exepack%m-%d-%Y.tar.gz")

#we need to compile the benchmark for each
for profile in ${ini_profiles[@]};
do
	#get shortname with which we will label the dir in the exepack
	shortname=${profile##*sfi}
	shortname=${shortname%%.ini}

	#replace the old cfg with the profile's cfg
	cp $ini_profiles_loc/$profile $cfg_loc/sched.ini

	#create dir for this profile
	profDir=$workDir/exepack/$shortname
	mkdir -p $profDir

	#build, & copy all the benchmarks
	#wipe the cmake build and rebuild it
	rm -rf $buildDir
	mkdir -p $buildDir
	cd $buildDir
	cmake -DCMAKE_INSTALL_PREFIX=$installDir -DCMAKE_C_COMPILER=$FLANG_INSTALL/bin/clang -DCMAKE_C_FLAGS="-target aarch64-linux-gnu -isystem /usr/aarch64-linux-gnu/include/ -mcpu=cortex-a72 -O3 -fplugin=$FLANG_INSTALL/lib/OptSched.so -mllvm -misched=optsched -mllvm -optsched-cfg=$cfg_loc" ..
	make install 2>&1 | tee $logDir/$shortname.log
	cd $hostProjectDir

	#recompute bmdirs after compile and ensure presence
	bmdirs=$(file */bin/* | grep -E ":.*aarch64"|cut -d: -f1| sed 's/\/[^/]*$//'|uniq|xargs)
	(cd $profDir; mkdir -p $bmdirs)


	#copy to exepack
	(cd $installDir;
		for e in $(file */bin/* | grep -E ":.*aarch64"|cut -d: -f1);
		do
			cp $e $profDir/$e
		done
	)
done

#tarball the exepack
(cd $workDir; tar -czf $packname exepack)

#if this option is selected then run commands to transfer the exepack and run it
if [ "$startExec" != "no" ];
then
	#ensure we have valid credentials/host information
	hs=$(ssh $ssh_id_opt $targetMachine "echo handshake")
	if [ $hs != "handshake" ];
	then
		echo "host not accessible"
		echo $hs
		exit
	fi
	#ensure that we have a exepack directory
	ssh $ssh_id_opt $targetMachine "mkdir -p $unpackDir"
	#and that there is nothing to conflict with the transfer
	ssh $ssh_id_opt $targetMachine "rm -rf $unpackDir/$packname"

	#copying exepack
	scp $ssh_id_opt $workDir/$packname $targetMachine:$unpackDir/

	#launch the exepack
	ssh $ssh_id_opt $targetMachine "tmux new-session -d bash -c \"cd $mediabenchDir; $runcom $packname $iterCnt; read\""
fi
