#!/bin/bash
set -e

current_dir=$(cd `dirname $0`; pwd)
echo $current_dir
pushd $current_dir

EXEC_FILE=""
if [ "$1" = "" ]; then
  EXEC_FILE="test"
else
  EXEC_FILE=$1
fi

adb shell "rm -rf /data/local/tmp/sample"
adb shell "mkdir -p /data/local/tmp/sample/arm64-v8a"

adb push $current_dir/libsample/build/android/arm64-v8a/test/$EXEC_FILE /data/local/tmp/sample/arm64-v8a/$EXEC_FILE
adb shell "chmod 777 /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"

adb shell "cd /data/local/tmp/sample && LD_LIBRARY_PATH=/data/local/tmp/sample/arm64-v8a/:$LD_LIBRARY_PATH /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"
#adb shell "cd /data/local/tmp/sample && LD_LIBRARY_PATH=/data/local/tmp/sample/arm64-v8a:$LD_LIBRARY_PATH /data/local/tmp/valgrind64/bin/valgrind --leak-check=full --track-origins=yes /data/local/tmp/sample/arm64-v8a/$EXEC_FILE"
