# mediabench_cmake

A version of the MediaBench benchmark that uses CMake for building instead of MediaBench's makefiles. Some CMake files are from the code in https://github.com/t-crest/patmos-benchmarks

## Usage

This repo contains scripts used for cross-compiling and running the benchmarks with our scheduler.
You may need to modify the scripts `compile_exe_pack.sh` and `install/run_exe_pack.sh` depending on the target platform or the options you want to use.


### Usage compile_exe_pack.sh:

`./compile_exe_pack.sh [iterations count (default 1000)] [yes|no (transfer to target and run,default no)]`

## Installation 

Copy the entire directory `install` to the target machine.
Change `hostProjectDir` on line 10 of `compile_exe_pack.sh` to be the location you cloned this repo to.

Put the `user@host` you use to access the target machine over ssh as the value of the variable `targetMachine` on line 4 of `compile_exe_pack.sh`
The auto cross compile and transfer scripts assume that you copy and rename the install dir to ~/mediabench on the target.
If you put the install elsewhere make sure to edit `mediabenchDir` on line 5 of `compile_exe_pack.sh` AND 
the variable `mediabenchDir` on line 7 of `run_exe_pack.sh` to reflect the location of the install on the target machine.

## Issues with some benchmarks

On the 64-bit ARM machines we are using for our research pegwit and ghoastscript crash you attempt to run them.  The pgp benchmark gets caught in an infinite loop.  
I suspect thtat these issues are caused by our use of a 64 bit platform, whereas the code is from the late 90s and likely only supported 32 bit machines.
