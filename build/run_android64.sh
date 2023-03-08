#!/bin/bash
set -e

current_dir=$(cd `dirname $0`; pwd)
echo $current_dir
pushd $current_dir

# try to detect NDK version
NDK_REL=$(grep -i '^Pkg.Revision'  $ANDROID_NDK/source.properties | awk -F '= ' '{print $2}')
NDK_VER=$(echo $NDK_REL | awk -F '.' '{print $1}')

HOST_OS=$(uname -s)
case $HOST_OS in
  Darwin) HOST_OS=darwin;;
  Linux) HOST_OS=linux;;
  FreeBsd) HOST_OS=freebsd;;
  CYGWIN*|*_NT-*) HOST_OS=cygwin;;
  *) echo "ERROR: Unknown host operating system: $HOST_OS"
     exit 1
esac
HOST_ARCH=$(uname -m)
case $HOST_ARCH in
  arm64) HOST_ARCH=arm64;;
  i?86) HOST_ARCH=x86;;
  x86_64|amd64) HOST_ARCH=x86_64;;
  *) echo "ERROR: Unknown host CPU architecture: $HOST_ARCH"
     exit 1
esac
NDK_HOST_TAG=$HOST_OS-$HOST_ARCH
if [ $NDK_HOST_TAG = darwin-arm64 ]; then
  # The NDK ships universal arm64+x86_64 binaries in the darwin-x86_64
  # directory.
  NDK_HOST_TAG=darwin-x86_64
fi

NDK_CLANG_VERSION=$(head -n 1 $ANDROID_NDK/toolchains/llvm/prebuilt/${NDK_HOST_TAG}/AndroidVersion.txt)
NDK_SYSROOT="$ANDROID_NDK/toolchains/llvm/prebuilt/${NDK_HOST_TAG}/sysroot"

adb shell "rm -rf /data/local/tmp/sample"
adb shell "mkdir -p /data/local/tmp/sample/arm64-v8a"

# push libc++_shared.so
adb push $NDK_SYSROOT/usr/lib/aarch64-linux-android/libc++_shared.so "/data/local/tmp/sample/arm64-v8a/"

# push asan library
adb push "$ANDROID_NDK/toolchains/llvm/prebuilt/${NDK_HOST_TAG}/lib64/clang/${NDK_CLANG_VERSION}/lib/linux/libclang_rt.asan-aarch64-android.so" "/data/local/tmp/sample/arm64-v8a/"

EXEC_FILE=""
if [ "$1" = "" ]; then
  EXEC_FILE="test"
else
  EXEC_FILE=$1
fi
adb push $current_dir/libsample/android/arm64-v8a/bin/$EXEC_FILE /data/local/tmp/sample/arm64-v8a/$EXEC_FILE
adb shell "chmod 777 /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"
# adb push $current_dir/libsample/android/arm64-v8a/lib/libsample.so /data/local/tmp/sample/arm64-v8a/libsample.so

adb shell "cd /data/local/tmp/sample && LD_LIBRARY_PATH=/data/local/tmp/sample/arm64-v8a/:$LD_LIBRARY_PATH /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"
#adb shell "cd /data/local/tmp/sample && LD_LIBRARY_PATH=/data/local/tmp/sample/arm64-v8a:$LD_LIBRARY_PATH /data/local/tmp/valgrind64/bin/valgrind --leak-check=full --track-origins=yes /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"
