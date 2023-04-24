#!/usr/bin/env bash

SUFFIX_REGEX=$1
FILE_PATH=$2

if [[ "$SUFFIX_REGEX" == "" ]]
then
    echo "** Please input Suffix Regex ***"
    exit 1
fi

buildResult="BUILD SUCCESS"
BUILD_SUCCESSFUL_COUNT=$(mvn -f $FILE_PATH dependency:tree -Dscope=compile -Dincludes=:::\*$buildResult | wc -l)

SNAPSHOT_DEPENDENCIES_COUNT=$(mvn -f $FILE_PATH dependency:tree -Dscope=compile -Dincludes=:::\*$SUFFIX_REGEX | awk '/'"$SUFFIX_REGEX"'/' | wc -l)

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n---\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo $(mvn -f $FILE_PATH  dependency:tree -Dscope=compile -Dincludes=:::\*$SUFFIX_REGEX | awk '/'"$SUFFIX_REGEX"'/')
  exit 1
elif [ "$BUILD_SUCCESSFUL_COUNT" -ne "1" ]
then
  echo "Build failed, please check input params again. SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
  exit 1
fi