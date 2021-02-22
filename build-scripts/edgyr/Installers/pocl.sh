#! /bin/bash

set -e

echo "Installing build dependencies"
sudo apt-get install -qqy --no-install-recommends \
  clang-10 \
  clang-format-10 \
  clang-tidy-10 \
  clang-tools-10 \
  clinfo \
  libclang-10-dev \
  libclang-cpp10-dev \
  libhwloc-dev \
  liblttng-ust-dev \
  llvm-10 \
  llvm-10-dev \
  llvm-10-runtime \
  llvm-10-tools \
  ocl-icd-dev \
  ocl-icd-opencl-dev \
  >> $EDGYR_LOGS/pocl.log 2>&1

echo "Cloning POCL"
mkdir --parents $HOME/src; cd $HOME/src
rm -fr pocl*
git clone https://github.com/edgyR/pocl.git

pushd pocl
git checkout nano-fixes
rm -fr build; mkdir --parents build; cd build

# LLVM 10 doesn't recognize a Xavier so we use "generic"
echo "CMake"
cmake \
  -G Ninja \
  -DLLC_HOST_CPU=generic \
  -DENABLE_CUDA=ON \
  -DINSTALL_OPENCL_HEADERS=1 \
  .. \
  >> $EDGYR_LOGS/pocl.log 2>&1

echo "Compiling POCL"
/usr/bin/time ninja \
  >> $EDGYR_LOGS/pocl.log 2>&1
echo "Installing POCL"
sudo ninja install \
  >> $EDGYR_LOGS/pocl.log 2>&1

sudo cp -rp /usr/local/etc/OpenCL /etc/
clinfo > $EDGYR_LOGS/clinfo.log 2>&1

echo "Running CUDA tests"
/usr/bin/time ../tools/scripts/run_cuda_tests \
  >> $EDGYR_LOGS/pocl.log 2>&1 || true
echo "CUDA tests finished"
popd

sudo cp $HOME/Installers/etc/pocl.conf /etc/ld.so.conf.d/
sudo /sbin/ldconfig --verbose \
  >> $EDGYR_LOGS/pocl.log 2>&1

echo "Installing / testing R 'OpenCL' package"
Rscript -e "source('~/Installers/R/OpenCL.R')" \
  >> $EDGYR_LOGS/pocl.log 2>&1

gzip -9 $EDGYR_LOGS/pocl.log
