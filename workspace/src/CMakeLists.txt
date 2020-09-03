cmake_minimum_required(VERSION 2.8.8)

project(app CXX)

find_package(OpenCV HINTS ${OpenCV_DIR})
include_directories(${OpenCV_INCLUDE_DIRS})

file(GLOB proj_srcs *.cpp)

add_executable(${CMAKE_PROJECT_NAME} ${proj_srcs})
target_link_libraries(${CMAKE_PROJECT_NAME} ${OpenCV_LIBS})