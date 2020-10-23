include_directories(${RSA_GLOBAL_INCLUDE})

add_library(rsaref STATIC
	desc.c
	digit.c
	md2c.c
	md5c.c
	nn.c
	prime.c
	r_encode.c
	r_enhanc.c
	r_keygen.c
	r_random.c
	rsa.c
	r_stdlib.c
)
