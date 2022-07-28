cmake_minimum_required(VERSION 3.5)

project(sample C CXX)

# benchmark
set(benchmark_DIR "${PROJECT_SOURCE_DIR}/3rdparty/libbenchmark")
find_package(benchmark REQUIRED CONFIG)

add_subdirectory(test)
