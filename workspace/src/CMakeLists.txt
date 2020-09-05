cmake_minimum_required(VERSION 2.8.8)
project(app CXX)

set(EXTRA_LIBS)

# ==========================================================
# OpenCV
# ==========================================================
find_package(OpenCV HINTS ${OpenCV_DIR})
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

