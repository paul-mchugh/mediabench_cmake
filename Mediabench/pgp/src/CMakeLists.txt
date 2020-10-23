include_directories(${RSA_GLOBAL_INCLUDE})
include_directories(${RSAREF_INCLUDE})

add_definitions(-DUNIX -DPORTABLE)

add_executable(pgp
	armor.c
	charset.c
	config.c
	crypto.c
	fileio.c
	genprime.c
	getopt.c
	idea.c
	keyadd.c
	keymaint.c
	keymgmt.c
	language.c
	md5.c
	mdfile.c
	more.c
	mpiio.c
	mpilib.c
	noise.c
	passwd.c
	pgp.c
	random.c
	randpool.c
	rsagen.c
	rsaglue2.c
	system.c
	zbits.c
	zdeflate.c
	zfile_io.c
	zglobals.c
	zinflate.c
	zip.c
	zipup.c
	ztrees.c
	zunzip.c
)

target_link_libraries(pgp rsaref)

install(TARGETS pgp
	RUNTIME DESTINATION pgp/bin)
