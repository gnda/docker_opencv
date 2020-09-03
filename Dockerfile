FROM ubuntu:groovy

LABEL maintainer="Kévin Nandacoumar <kevin.nandacoumar@gmail.com>"

ADD ./scripts/opencv.sh /opt/scripts/opencv.sh

RUN apt-get update && apt-get upgrade -y &&\
	apt-get install -y build-essential cmake-qt-gui doxygen git graphviz qt5-default &&\
	chmod +x -R /opt/scripts && /bin/bash -c '/opt/scripts/opencv.sh'