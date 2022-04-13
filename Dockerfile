FROM ubuntu:20.04 as simpleitk-doxygen

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  cmake \
  bison \
  build-essential \
  curl \
  flex \
  git \
  ninja-build \
  graphviz \
  python \
  && apt-get clean

RUN git clone https://github.com/doxygen/doxygen.git && \
    ( cd doxygen && \
      git checkout Release_1_9_3 && \
      mkdir bld && cd bld && \
      cmake -G Ninja -DCMAKE_BUILD_TYPE=Release .. && \
      ninja install) && \
    rm -rf ./doxygen

RUN git config --global url."https://github.com/InsightSoftwareConsortium/".insteadOf "https://itk.org/"

COPY run.sh /tmp

#COPY patch /tmp/patch

WORKDIR /work

ENTRYPOINT ["/tmp/run.sh"]
