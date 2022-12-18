# Author : Rancune (rancune@rancune.org)
# Description : Makefile for stm32 toolchain building

TARGET = arm-none-eabi
PREFIX = ${PWD}/toolchains/${TARGET}
MAKE_OPTS = -j15

WORKDIR = ${PWD}/build
WORKDIR_BINUTILS = ${WORKDIR}/binutils
WORKDIR_GCC = ${WORKDIR}/gcc
WORKDIR_LIBC = ${WORKDIR}/libc


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

# --prefix=/data/jenkins/workspace/GNU-toolchain/arm-12-mpacbti/build-arm-none-eabi/install \
# --with-sysroot=/data/jenkins/workspace/GNU-toolchain/arm-12-mpacbti/build-arm-none-eabi/install/arm-none-eabi \

GCC01_CONFIGURE = \
	--target=${TARGET} \
	--prefix=${PREFIX} \
	--disable-shared \
	--disable-nls \
	--disable-threads \
	--disable-tls \
	--enable-checking=release \
	--enable-languages=c \
	--without-cloog \
	--without-isl \
	--with-newlib \
	--without-headers \
	--with-gnu-as \
	--with-gnu-ld \
	--with-multilib-list=rmprofile

LIBC_CONFIGURE= \
	--disable-newlib-supplied-syscalls \
	--target=${TARGET} \
	--prefix=${PREFIX} 

all: binutils

binutils: 
	mkdir -p ${WORKDIR_BINUTILS}
	cd ${WORKDIR_BINUTILS} && ../../git/binutils-gdb.git/configure ${BINUTILS_CONFIGURE}
	cd ${WORKDIR_BINUTILS} && make ${MAKE_OPTS}
	cd ${WORKDIR_BINUTILS} && make install

gcc_01:
	mkdir -p ${WORKDIR_GCC}
	cd ${WORKDIR_GCC} && ../../git/gcc.git/configure ${GCC01_CONFIGURE}
	cd ${WORKDIR_GCC} && make ${MAKE_OPTS} all-gcc
	cd ${WORKDIR_GCC} && make install-gcc

libc:
	mkdir -p ${WORKDIR_LIBC}
	export PATH=${PREFIX}/bin:${PATH} ; cd ${WORKDIR_LIBC} ; ../../git/newlib-cygwin.git/configure ${LIBC_CONFIGURE}
	export PATH=${PREFIX}/bin:${PATH} ; cd ${WORKDIR_LIBC} ; make ${MAKE_OPTS} 
	export PATH=${PREFIX}/bin:${PATH} ; cd ${WORKDIR_LIBC} ; make install

