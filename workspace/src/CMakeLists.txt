cmake_minimum_required(VERSION 2.8.8)
project(app CXX)

set(EXTRA_LIBS)

# ==========================================================
# OpenCV
# ==========================================================

# If the variable OPENCV_DIR_HINT has not been set
if (NOT DEFINED OPENCV_DIR_HINT)
  # In case the environment variable OPENCV_INSTALL_DIR is set and
  # CMAKE_BUILD_TYPE has been set (debug/release), link with OpenCV built
  # in Debug if we build in Dbug, link with OpenCV built in Release in we
  # build in Release
  if (DEFINED ENV{OPENCV_INSTALL_DIR} AND DEFINED CMAKE_BUILD_TYPE)
    string(TOLOWER "${CMAKE_BUILD_TYPE}" build_type_LOWER)
    set(OPENCV_DIR_HINT "$ENV{OPENCV_INSTALL_DIR}/${build_type_LOWER}")
  endif()
endif()

find_package(OpenCV HINTS ${OPENCV_DIR_HINT})
if (${OpenCV_VERSION_MAJOR} LESS 3)
  message(WARNING "OpenCV version should be 3.0.0 or greater. Found version: ${OpenCV_VERSION}")
endif()
include_directories(${OpenCV_INCLUDE_DIRS})
list(APPEND EXTRA_LIBS ${OpenCV_LIBS})

# ==========================================================
# In case OpenCV is using Qt
# ==========================================================
find_package(Qt5 COMPONENTS Concurrent Core Gui Test Widgets)
if(Qt5_FOUND)
  list(APPEND EXTRA_LIBS Qt5::Concurrent Qt5::Core Qt5::Gui Qt5::Test Qt5::Widgets)
endif()

# ==========================================================
# In case OpenCV is using OpenMP
# ==========================================================
find_package(OpenMP)
if(OpenMP_CXX_FOUND)
  list(APPEND EXTRA_LIBS OpenMP::OpenMP_CXX)
endif()

# ==========================================================
# Project
# ==========================================================
file(GLOB proj_srcs *.cpp)
add_executable(${CMAKE_PROJECT_NAME} ${proj_srcs})
target_link_libraries(${CMAKE_PROJECT_NAME} ${EXTRA_LIBS})

