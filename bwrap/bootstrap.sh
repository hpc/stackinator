#!/bin/bash
set -e

basepath=$(pwd)
installpath=${basepath}/local
mkdir -p ${installpath}

echo "log file" > log

libcapversion=2.68
libcaptarfile=libcap-${libcapversion}.tar.gz
libcapurl=https://www.kernel.org/pub/linux/libs/security/linux-privs/libcap2/${libcaptarfile}
wget -nv $libcapurl >> log
tar -xzvf $libcaptarfile >> log

cd libcap-${libcapversion}
make RAISE_SETFCAP=no GOLANG=no USE_GPERF=no SHARED=yes lib=lib prefix=$installpath install >> log

cd ${basepath}

bwrapversion=0.8.0
bwraptarfile=bubblewrap-${bwrapversion}.tar.xz
bwrapurl=https://github.com/containers/bubblewrap/releases/download/v${bwrapversion}/${bwraptarfile}
wget -nv ${bwrapurl} >> log
tar -xvf ${bwraptarfile} >> log

cd bubblewrap-${bwrapversion}
CFLAGS="-I${installpath}/include -L${installpath}/lib" ./configure --disable-sudo --disable-man --without-bash-completion-dir --prefix=${installpath} >> log
make install >> log
