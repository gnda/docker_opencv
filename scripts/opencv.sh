#!/usr/bin/env bash
set -e

# Colors
readonly TC_BLU="\\033[0;96m"
readonly TC_STD="\\033[0;39m"

# ============================================================================
# Display an information message
# ============================================================================
f_info() {
  echo -e "${TC_BLU}$@${TC_STD}"
}

# ============================================================================
# Install a package
# ============================================================================
f_install() {
  for item in "$@"; do
    f_info " - ${item} "
    apt-get install -qy ${item}
  done
}

# ============================================================================
# Installing packages
# ============================================================================
packages=(
   libatlas-base-dev
#  libeigen3-dev
   libgtk-3-dev
   liblapacke-dev

   # FFMPEG
   libavcodec-dev
   libavformat-dev
   libavresample-dev
   libswscale-dev

   # GStreamer
   gstreamer1.0-dev 
   gstreamer1.0-doc
   gstreamer1.0-plugins-base
   gstreamer1.0-plugins-good
   gstreamer1.0-plugins-bad
   gstreamer1.0-plugins-ugly
   gstreamer1.0-libav
   gstreamer1.0-tools
   gstreamer1.0-alsa
   gstreamer1.0-gl
   gstreamer1.0-gtk3
   gstreamer1.0-qt5
   gstreamer1.0-pulseaudio
   libgstreamer1.0-0
   libgstreamer1.0-dev
   libgstreamer-plugins-base1.0-dev

#  liblas-dev
#  libopenblas-dev
)
f_info    "Install all required packages"
f_install "${packages[@]}"

# ============================================================================
# OpenCV
# ============================================================================
f_info "Clone opencv repo's"
mkdir -p /data && chmod a+rw /data && cd /data 
git clone --depth 1 https://github.com/opencv/opencv.git
git clone --depth 1 https://github.com/opencv/opencv_contrib.git

# ============================================================================
# Debug
# ============================================================================
f_info "Build OpenCV in debug..."
mkdir -p ~/opencv_build_debug
cd ~/opencv_build_debug
cmake \
 -D CMAKE_BUILD_TYPE=DEBUG \
 -D CMAKE_INSTALL_PREFIX=/usr/local/opencv/debug \
 -D BUILD_DOCS:BOOL=OFF \
 -D BUILD_EXAMPLES:BOOL=OFF \
 -D BUILD_JAVA:BOOL=OFF \
 -D BUILD_PERF_TESTS:BOOL=OFF \
 -D BUILD_SHARED_LIBS:BOOL=OFF \
 -D BUILD_TESTS:BOOL=OFF \
 -D WITH_QT:BOOL=ON \
 -D OPENCV_EXTRA_MODULES_PATH=/data/opencv_contrib/modules \
 /data/opencv
make --jobs=2 && make install
rm -Rf ~/opencv*

# ============================================================================
# Release
# ============================================================================
f_info "Build OpenCV in release..."
mkdir -p ~/opencv_build_release
cd ~/opencv_build_release
cmake \
 -D CMAKE_BUILD_TYPE=RELEASE \
 -D CMAKE_INSTALL_PREFIX=/usr/local/opencv/release \
 -D BUILD_DOCS:BOOL=ON \
 -D BUILD_EXAMPLES:BOOL=ON \
 -D BUILD_JAVA:BOOL=OFF \
 -D BUILD_PERF_TESTS:BOOL=OFF \
 -D BUILD_SHARED_LIBS:BOOL=OFF \
 -D BUILD_TESTS:BOOL=OFF \
 -D WITH_QT:BOOL=ON \
 -D OPENCV_EXTRA_MODULES_PATH=/data/opencv_contrib/modules \
 /data/opencv
make --jobs=2 && make doxygen && make install
mkdir -p /usr/local/opencv/release/samples
mv bin/example_* /usr/local/opencv/release/samples/
rm -Rf ~/opencv*

