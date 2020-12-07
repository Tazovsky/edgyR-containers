#! /bin/bash

echo "Installing build dependencies"
apt-get update
apt-get upgrade -y
apt-get install -qqy --no-install-recommends \
  ant \
  apt-file \
  autoconf \
  automake \
  build-essential \
  ca-certificates \
  cabal-install \
  clang \
  cmake \
  curl \
  debsigs \
  dpkg-sig \
  expect \
  fakeroot \
  file \
  gfortran \
  git \
  git-lfs \
  gnupg \
  haskell-platform \
  haskell-stack \
  libacl1-dev \
  libattr1-dev \
  libbz2-dev \
  libcairo2-dev \
  libcap-dev \
  libclang-3.9-dev \
  libclang-4.0-dev \
  libclang-5.0-dev \
  libclang-6.0-dev \
  libclang-7-dev \
  libclang-8-dev \
  libclang-9-dev \
  libclang-10-dev \
  libclang-dev \
  libcurl4-openssl-dev \
  libegl1-mesa \
  libfuse2 \
  libgl1-mesa-dev \
  libgmp-dev \
  libgtk-3-0 \
  libicu-dev \
  libjpeg-turbo8-dev \
  libjpeg8-dev \
  liblzma-dev \
  libncurses-dev \
  libnuma-dev \
  libpam-dev \
  libpango1.0-dev \
  libpcre2-dev \
  libreadline-dev \
  libssl-dev \
  libtiff5-dev \
  libuser1-dev \
  libxslt1-dev \
  llvm-3.9 \
  llvm-4.0 \
  llvm-5.0 \
  llvm-6.0 \
  llvm-7 \
  llvm-8 \
  llvm-9 \
  llvm-10 \
  lsof \
  mlocate \
  netbase \
  openjdk-8-jdk \
  patchelf \
  pkg-config \
  python \
  python3 \
  python3-sphinx \
  rrdtool \
  software-properties-common \
  sudo \
  texinfo \
  time \
  tk-dev \
  tree \
  unzip \
  uuid-dev \
  vim-nox \
  wget \
  zip \
  zlib1g-dev
apt-get clean

if [ `uname -m` = "x86_64" ]
then
  update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java
else
  update-alternatives --set java /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java
fi
