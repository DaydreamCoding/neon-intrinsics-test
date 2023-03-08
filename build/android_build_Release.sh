#!/bin/bash
set -e

current_dir=$(cd `dirname $0`; pwd)
echo $current_dir
pushd $current_dir

# ANDROID_NDK env
if [ "$ANDROID_NDK" = "" ]; then
    ANDROID_NDK=$(dirname `which ndk-build`)
    echo "set ANDROID_NDK by path of ndk-buid : $ANDROID_NDK"
else
    echo "find ANDROID_NDK from system env : $ANDROID_NDK"
fi

if [ "$ANDROID_NDK" = "" ]; then
    echo "can't find ANDROID_NDK env and ndk-buid, please set before run"
    exit 1;
fi

# try to detect NDK version
NDK_REL=$(grep -i '^Pkg.Revision'  $ANDROID_NDK/source.properties | awk -F '= ' '{print $2}')
NDK_VER=$(echo $NDK_REL | awk -F '.' '{print $1}')
if [ "$NDK_VER" -lt "21" ]; then
    echo "You need the ndk-r21 or later"
    exit 1
fi

# 编译的平台
if [ "$ALL_ARCHS" = "" ]; then
    ALL_ARCHS="$ALL_ARCHS arm64-v8a"
    #ALL_ARCHS="$ALL_ARCHS armeabi-v7a"
    #ALL_ARCHS="$ALL_ARCHS armeabi"
    #ALL_ARCHS="$ALL_ARCHS x86"
    #ALL_ARCHS="$ALL_ARCHS x86_64"
fi

# 是否清除编译的缓存
if [ "$CLEAN_CACHE" = "" ]; then
    CLEAN_CACHE="ON"
fi

BUILD_HIDDEN_SYMBOL="ON"   ## 隐藏符号ON, 不隐藏符号OFF
BUILD_RTTI="OFF"           ## rtti switch
BUILD_EXCEPTIONS="OFF"     ## exceptions switch
PROJECT_NAME="sample"      ## 项目名称

COMMON_CMAKE_ARGS=("${ASSIGNED_CMAKE_ARGS[@]}")
COMMON_CMAKE_ARGS+=("-DCMAKE_TOOLCHAIN_FILE=$ANDROID_NDK/build/cmake/android.toolchain.cmake") # 使用NDK r21e以上版本
COMMON_CMAKE_ARGS+=("-DANDROID_NDK=$ANDROID_NDK")
COMMON_CMAKE_ARGS+=("-DCMAKE_INSTALL_PREFIX=/")
COMMON_CMAKE_ARGS+=("-DCMAKE_BUILD_TYPE=Release")
COMMON_CMAKE_ARGS+=("-DBUILD_SHARED_LIBS=OFF")

do_build()
{
    BUILD_ARCH=$1

    CMAKE_ARGS=("${COMMON_CMAKE_ARGS[@]}")
    CMAKE_ARGS+=("-DANDROID_ABI=$BUILD_ARCH")
    if [ "$BUILD_ARCH" == "armeabi-v7a" ]; then
        CMAKE_ARGS+=("-DANDROID_ARM_NEON=TRUE")
        CMAKE_ARGS+=("-DANDROID_STL=c++_shared")
        CMAKE_ARGS+=("-DANDROID_TOOLCHAIN=clang")
        CMAKE_ARGS+=("-DANDROID_PLATFORM=android-16")
    else
        CMAKE_ARGS+=("-DANDROID_STL=c++_shared")
        CMAKE_ARGS+=("-DANDROID_TOOLCHAIN=clang")
        CMAKE_ARGS+=("-DANDROID_PLATFORM=android-21")
    fi

    # 编译安装目录
    if [ "$BUILD_BASE_DIR" = "" ]; then
        BUILD_BASE_DIR="android"
    fi

    # 编译安装目录
    OUTPUT_DIR="$current_dir/lib${PROJECT_NAME}/${BUILD_BASE_DIR}/$BUILD_ARCH"
    BUILD_DIR="$current_dir/lib${PROJECT_NAME}/build/${BUILD_BASE_DIR}/$BUILD_ARCH"

    # 清除编译缓存
    if [ "$CLEAN_CACHE" == "ON" ]; then
        rm -rf "$BUILD_DIR"
    fi
    mkdir -p "$BUILD_DIR"
    pushd "$BUILD_DIR"

    cmake "${CMAKE_ARGS[@]}" \
          $current_dir/..

    #cmake --build .
    make all -j8
    #rm -rf "$OUTPUT_DIR"
    make install/strip DESTDIR="$OUTPUT_DIR"
    popd # $BUILD_DIR
}

# 开始编译
for ARCH in $ALL_ARCHS
do
    do_build $ARCH
done

popd # $current_dir
