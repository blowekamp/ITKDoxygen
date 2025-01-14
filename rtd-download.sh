#!/usr/bin/env bash

set -eox

DOC_VERSION=$(if [[ "${READTHEDOCS_GIT_IDENTIFIER}" == *v* ]]; then echo "${READTHEDOCS_GIT_IDENTIFIER}"; else echo "latest"; fi)
DOC_VERSION_NO_V=${DOC_VERSION//v/}
curl -LO https://github.com/thewtex/ITKDoxygen/releases/download/${DOC_VERSION}/InsightDoxygenDocHtml-${DOC_VERSION_NO_V}.tar.zst

unzstd --long=31 ./InsightDoxygenDocHtml-${DOC_VERSION_NO_V}.tar.zst
mkdir -p $READTHEDOCS_OUTPUT/html
tar xf \
  ./InsightDoxygenDocHtml-${DOC_VERSION_NO_V}.tar \
  --strip-components=1 \
  -C $READTHEDOCS_OUTPUT/html

