cmake_minimum_required(VERSION 3.5)

project(sample C CXX)

message(STATUS "ANDROID_NDK: " ${ANDROID_NDK})

add_compile_options(-fsanitize=address)
add_compile_options(-fno-omit-frame-pointer)
add_link_options   (-fsanitize=address)

add_subdirectory(test)
