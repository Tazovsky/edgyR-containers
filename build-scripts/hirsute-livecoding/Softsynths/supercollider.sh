#! /bin/bash

# Copyright (C) 2021 M. Edward (Ed) Borasky <mailto:znmeb@algocompsynth.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
# 
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

# https://github.com/supercollider/supercollider/wiki/Installing-supercollider-from-source-on-Ubuntu

set -e
cd $PROJECT_HOME

echo "Installing SuperCollider Linux dependencies"
sudo apt-get install -y --no-install-recommends \
  libavahi-client-dev \
  libfftw3-dev \
  libfftw3-mpi-dev \
  libncurses5-dev
sudo apt-get clean

echo "Downloading supercollider source"
rm -fr SuperCollider*
export SUPERCOLLIDER_REPO="https://github.com/supercollider/supercollider/releases/download/Version-$SUPERCOLLIDER_VERSION"
export SUPERCOLLIDER_FILE="SuperCollider-$SUPERCOLLIDER_VERSION-Source.tar.bz2"
curl -Ls $SUPERCOLLIDER_REPO/$SUPERCOLLIDER_FILE \
  | tar --extract --bzip2 --file=-
pushd SuperCollider*
  export SC_PATH=$PWD

  echo "Configuring supercollider"
  rm -fr build && mkdir build && cd build
  cmake \
    -Wno-dev \
    -DCMAKE_BUILD_TYPE=Release \
    -DNATIVE=ON \
    -DSC_ABLETON_LINK=OFF \
    -DENABLE_TESTSUITE=OFF \
    -DLIBSCSYNTH=OFF \
    -DINSTALL_HELP=OFF \
    -DNO_X11=ON \
    -DSCLANG_SERVER=ON \
    -DSC_IDE=OFF \
    -DSC_QT=OFF \
    -DSC_ED=OFF \
    .. \

  echo "Compiling supercollider"
  make --jobs=`nproc`

  echo "Installing supercollider"
  sudo make install
  sudo ldconfig
  popd

echo "Downloading sc3-plugins source"
rm -fr sc3-plugins*
export SC3_PLUGINS_REPO="https://github.com/supercollider/sc3-plugins/releases/download/Version-$SC3_PLUGINS_VERSION"
export SC3_PLUGINS_FILE="sc3-plugins-$SC3_PLUGINS_VERSION-Source.tar.bz2"
curl -Ls $SC3_PLUGINS_REPO/$SC3_PLUGINS_FILE \
  | tar --extract --bzip2 --file=-
pushd sc3-plugins*

  echo "Building sc3-plugins"
  mkdir build && cd build
  cmake \
    -Wno-dev \
    -DCMAKE_BUILD_TYPE=Release \
    -DNATIVE=ON \
    -DQUARKS=ON \
    ..
  make --jobs=`nproc`
  echo "Installing sc3-plugins"
  sudo make install
  sudo ldconfig
  popd

echo "Cleanup"
rm -fr $PROJECT_HOME/SuperCollider*
rm -fr $PROJECT_HOME/sc3-plugins*

echo "Finished"
