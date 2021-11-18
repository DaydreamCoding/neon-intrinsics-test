cmake_minimum_required(VERSION 3.5)

project(sample C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF) ## on g++ this ensures: -std=c++11 and not -std=gnu++11

include (${PROJECT_SOURCE_DIR}/cmakes/config.cmake)

# benchmark
set(benchmark_DIR "${PROJECT_SOURCE_DIR}/3rdparty/libbenchmark")
find_package(benchmark REQUIRED CONFIG)

add_subdirectory(test)
