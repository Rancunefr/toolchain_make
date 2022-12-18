# Author : Rancune (rancune@rancune.org)
# Description : Makefile for stm32 toolchain building

TARGET = arm-none-eabi
PREFIX = ${PWD}/toolchains/${TARGET}
MAKE_OPTS = -j15

WORKDIR = ${PWD}/build
WORKDIR_BINUTILS = ${WORKDIR}/binutils

BINUTILS_CONFIGURE = \
    --enable-initfini-array \
    --disable-nls \
    --without-x \
    --disable-gdbtk \
    --without-tcl \
    --without-tk \
    --enable-plugins \
    --disable-gdb \
    --without-gdb \
    --target=${TARGET} \
    --prefix=${PREFIX}

all: binutils 

binutils: 
	mkdir -p ${WORKDIR_BINUTILS}
	cd ${WORKDIR_BINUTILS} && ../../git/binutils-gdb.git/configure ${BINUTILS_CONFIGURE}
	cd ${WORKDIR_BINUTILS} && make ${MAKE_OPTS}
	cd ${WORKDIR_BINUTILS} && make install


