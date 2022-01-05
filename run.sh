#!/usr/bin/env bash



SRC_DIR="/work/ITK"
BLD_DIR="/work/ITK-bld"

# If the SRC_DIR is not mounted, then this tag will be checked out
GIT_TAG=${GIT_TAG:-"master"}

set -xe


if [ ! -d ${SRC_DIR} ]; then
    ( git clone https://github.com/InsightSoftwareConsortium/ITK.git ${SRC_DIR} &&
          cd ${SRC_DIR} &&
          git checkout ${GIT_TAG} &&
          if [ -d /tmp/patch ]; then git apply /tmp/patch/*.patch; fi
    )
fi


mkdir -p ${BLD_DIR} && \
    cd ${BLD_DIR} && \
    cmake -G Ninja\
          -DITK_BUILD_DOCUMENTATION=ON\
          -DITK_DOXYGEN_XML:BOOL=ON\
          ${SRC_DIR} && \
    cmake --build . --target Documentation && \
    cd ${BLD_DIR}/Utilities/Doxygen && \
    tar --exclude=\*.md5 --exclude=\*.map -zcvf /ITKDoxygen.tar.gz ./html && \
    tar -zcvf /ITKDoxygenXML.tar.gz ./xml
