FROM ubuntu:18.04

LABEL maintainer="Philippe Foubert <philippe.foubert@free.fr>"

ADD ./scripts/opencv.sh /opt/scripts/opencv.sh

RUN apt-get update && apt-get upgrade -y && \
apt-get install -y build-essential cmake-qt-gui doxygen git gdb graphviz qt5-default && \
chmod +x -R /opt/scripts && /bin/bash -c '/opt/scripts/opencv.sh'

