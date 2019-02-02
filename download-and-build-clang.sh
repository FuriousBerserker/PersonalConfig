#!/bin/bash
#module load cmake/3.6.0 clang/7.0-master cuda/91

if [ $# -lt 3 ]; then
    echo "download-and-build-clang.sh <SRC FOLDER> <BUILD FOLDER> <INSTALL FOLDER>"
    exit 1
fi

SRC=$1
BUILD=$2
INSTALL=$3

if [ -z $SRC ] || [ ! -w $SRC ]; then
    echo "SRC folder $SRC does not exist"
    exit 1
fi

if [ -z $BUILD ] || [ ! -w $BUILD ]; then
    echo "BUILD folder $BUILD does not exist"
    exit 1
fi

if [ -z $INSTALL ] || [ ! -w $INSTALL ]; then
    echo "INSTALL folder $INSTALL does not exist"
    exit 1
fi

cd $SRC
if [ ! -e $SRC/llvm ]; then
  cd $SRC
  mkdir llvm
  git clone https://github.com/llvm-mirror/llvm.git llvm
  cd $SRC/llvm/projects
  mkdir compiler-rt
  git clone https://github.com/llvm-mirror/compiler-rt.git compiler-rt
  mkdir libcxxabi
  git clone https://github.com/llvm-mirror/libcxxabi.git libcxxabi
  mkdir libcxx
  git clone https://github.com/llvm-mirror/libcxx.git libcxx
#  cd $SRC/llvm/projects/libunwind
#  git clone https://github.com/llvm-mirror/libunwind.git
  mkdir openmp
  git clone https://github.com/llvm-mirror/openmp.git openmp
  cd $SRC/llvm/tools
  mkdir clang
  git clone https://github.com/llvm-mirror/clang.git clang
fi

if [ ! -e $BUILD/llvm/bootstrap ]; then
  mkdir -p $BUILD/llvm/bootstrap
fi

cd $BUILD/llvm/bootstrap
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL/clang-bootstrap/ -DLLVM_ENABLE_LIBCXX=ON -DCLANG_DEFAULT_CXX_STDLIB=libc++ $SRC/llvm
make -j$[$(nproc --all) * 2 / 3] install

PATH=$BUILD/llvm/bootstrap/bin:$PATH
LD_LIBRARY_PATH=$BUILD/llvm/bootstrap/lib:$LD_LIBRARY_PATH


if [ ! -e $BUILD/llvm/clang-full ]; then
  mkdir -p $BUILD/llvm/clang-full
fi

cd $BUILD/llvm/clang-full
CC=clang CXX=clang++ cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$INSTALL/clang-full -DLIBOMP_OMPT_SUPPORT=on -DLLVM_ENABLE_LIBCXX=ON -DLLVM_LIT_ARGS="-sv -j12" -DCLANG_DEFAULT_CXX_STDLIB=libc++ $SRC/llvm
            #-DCLANG_OPENMP_NVPTX_DEFAULT_ARCH=sm_70 \
            #-DLIBOMPTARGET_NVPTX_COMPUTE_CAPABILITIES=35,60,70 \
make -j$[$(nproc --all) * 2 / 3] install
