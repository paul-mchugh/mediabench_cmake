SET(RSAREF_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/rsaref/source/)
SET(RSA_GLOBAL_INCLUDE ${CMAKE_CURRENT_SOURCE_DIR}/rsaref/install/unix)

add_subdirectory(rsaref/source)
add_subdirectory(src)
