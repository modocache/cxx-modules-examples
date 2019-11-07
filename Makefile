CC := ${HOME}/Source/llvm/git/dev/llvm-project/build/bin/clang++
CXXFLAGS := -std=c++2a -stdlib=libc++

HOST_OS := $(shell uname -s)
ifeq ($(HOST_OS),Darwin)
	SDK_PATH = $(shell xcrun --show-sdk-path)
	CXXFLAGS += -isysroot ${SDK_PATH}
endif

ROOTDIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
C20MD = ${ROOTDIR}/cxx20-modules
HUD = ${C20MD}/atom-style-header-units

clean:
	rm -f foo.o foo.pcm main bar.h.gch header.pcm

cxx20-modules: cxx20-modules-001

cxx20-modules-001: SRCDIR = ${C20MD}/001-using-a-cppm
cxx20-modules-001:
	# 1. Pre-compile module interface source file 'foo.cppm' into 'foo.pcm'.
	${CC} \
		${CXXFLAGS} \
		--precompile \
		${SRCDIR}/foo.cppm \
		-o ${SRCDIR}/foo.pcm
	# 2. Compile C++ source file 'foo.cppm' into object file 'foo.o'.
	${CC} \
		${CXXFLAGS} \
		-c \
		${SRCDIR}/foo.cppm \
		-o ${SRCDIR}/foo.o
	# 3. Compile and link 'main'.
	${CC} \
		${CXXFLAGS} \
		-fmodule-file=${SRCDIR}/foo.pcm \
		${SRCDIR}/foo.o ${SRCDIR}/main.cpp \
		-o ${SRCDIR}/main


cxx20-modules-atom-style-header-units: cxx20-modules-atom-style-header-units-001

cxx20-modules-atom-style-header-units-001: SRCDIR = ${HUD}/001-using-a-header-unit
cxx20-modules-atom-style-header-units-001:
	# 1. Pre-compile header unit 'bar.h' into a module interface 'bar.pcm'.
	#    Note we need to pass the include path to 'bar.h'.
	${CC} \
		${CXXFLAGS} \
		-I${SRCDIR}/bar \
		--precompile \
		-x c++-header ${SRCDIR}/bar/bar.h \
		-fmodule-name=bar \
		-o ${SRCDIR}/bar/bar.pcm
	# 2. Pre-compile module interface source file 'foo.cppm' into 'foo.pcm'.
	#    Because 'foo.pcm' imports header unit 'bar.h', we pass the pre-compiled
	#    interface of that header unit in via '-fmodule-file='.
	${CC} \
		${CXXFLAGS} \
		-fmodule-file=${SRCDIR}/bar/bar.pcm \
		--precompile \
		${SRCDIR}/foo.cppm \
		-o ${SRCDIR}/foo.pcm
	# 3. Compile C++ source file 'foo.cppm' into object file 'foo.o'. Once again,
	#    we must pass in '-fmodule-file=' pointing to header unit 'bar.h'.
	${CC} \
		${CXXFLAGS} \
		-fmodule-file=${SRCDIR}/bar/bar.pcm \
		-c \
		${SRCDIR}/foo.cppm \
		-o ${SRCDIR}/foo.o
	# 4. Compile and link 'main'.
	${CC} \
		${CXXFLAGS} \
		-fmodule-file=${SRCDIR}/foo.pcm \
		-fmodule-file=${SRCDIR}/bar/bar.pcm \
		-I${SRCDIR}/bar \
		${SRCDIR}/foo.o ${SRCDIR}/main.cpp \
		-o ${SRCDIR}/main
