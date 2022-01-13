FROM ubuntu:bionic
LABEL maintainer="Kamil Foltyński <kamil@foltynski.com"

ARG DEBIAN_FRONTEND=noninteractive
USER root

ENV SOURCE_DIR=/usr/local/src
ENV LOGS=$SOURCE_DIR/logs
ENV SCRIPTS=$SOURCE_DIR/scripts
ENV PACKAGES=$SOURCE_DIR/packages
RUN mkdir --parents $LOGS $SCRIPTS $PACKAGES
RUN ls -FlarRt /usr/local > $LOGS/before.log

WORKDIR $SOURCE_DIR

# assume dark background for vim
RUN echo "set bg=dark" >> /root/.vimrc

# RAM query script
COPY ram_kilobytes.sh /usr/local/bin/

# Pandoc
ENV PANDOC_VERSION="2.13"
COPY upstream-pandoc.sh $SCRIPTS/
RUN $SCRIPTS/upstream-pandoc.sh

# R
ENV R_VERSION_MAJOR=4 R_VERSION_MINOR=1 R_VERSION_PATCH=2
ENV R_LATEST=R-$R_VERSION_MAJOR.$R_VERSION_MINOR.$R_VERSION_PATCH
COPY r-from-source.sh $SCRIPTS/
RUN $SCRIPTS/r-from-source.sh
COPY configure.sh R.conf $SCRIPTS/
RUN /usr/bin/time $SCRIPTS/configure.sh

# PGDG repository
COPY pgdg.sh pgdg.list $SCRIPTS/
RUN $SCRIPTS/pgdg.sh

# install RStudio Server
# see https://rstudio.com/products/rstudio/download-server/other-platforms/
ENV RSTUDIO_VERSION_MAJOR=1 RSTUDIO_VERSION_MINOR=4 RSTUDIO_VERSION_PATCH=1106
COPY rstudio.sh $SCRIPTS/
COPY dependencies/linux $SCRIPTS/dependencies/linux
COPY dependencies/common $SCRIPTS/dependencies/common
RUN /usr/bin/time $SCRIPTS/rstudio.sh

COPY build-libnode-dev.sh cran-ubuntu-v8-bionic.list sources.list $SCRIPTS/
# RUN $SCRIPTS/build-libnode-dev.sh

