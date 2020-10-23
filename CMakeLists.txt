project(mediabench)

cmake_minimum_required(VERSION 2.8)

# we are only using C at the moment
enable_language(C)

# we override add_executable to collect a list of executables in the global property tgt_list_prop
# and use it in setup_all_link_flags().
# IMPORTANT: this overriding of a CMake builtin is fragile, DON'T move it to included scripts!
function(add_executable TARGET)
  set_property(GLOBAL APPEND PROPERTY tgt_list_prop ${TARGET})
  _add_executable(${TARGET} ${ARGN})
endfunction()

set(BUILD_WCET_ANALYSIS false CACHE BOOL "Compile for WCET analysis where applicable (eg. no printfs).")
set(TACLE_BENCH false CACHE BOOL "Use TACLe version of benchmarks when available (transitional).")

add_subdirectory(Mediabench)
