FROM ubuntu:groovy

LABEL maintainer="Kévin Nandacoumar <kevin.nandacoumar@gmail.com>"

ARG OPENCV_VERSION="4.4.0"

# install dependencies &download opencv
RUN apt-get update &&\
	apt-get install -y libopencv-dev cmake &&\
	apt-get install -y curl build-essential cmake &&\
	curl -sL https://github.com/opencv/opencv/archive/$OPENCV_VERSION.tar.gz | tar xvz -C /tmp &&\
	curl -sL https://github.com/opencv/opencv_contrib/archive/$OPENCV_VERSION.tar.gz | tar xvz -C /tmp &&\
    mkdir -p /tmp/opencv-$OPENCV_VERSION/build &&\
    mkdir -p /tmp/opencv_contrib-$OPENCV_VERSION/build

WORKDIR /tmp/opencv-$OPENCV_VERSION/build

# install
RUN cmake -DOPENCV_EXTRA_MODULE_PATH=/tmp/opencv_contrib-$OPENCV_VERSION/modules .. &&\
	make &&\
	make install &&\
	echo "/usr/local/lib" > /etc/ld.so.conf.d/opencv.conf &&\
	ldconfig &&\
	ln /dev/null /dev/raw1394

WORKDIR /src