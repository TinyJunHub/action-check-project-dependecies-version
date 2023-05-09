#!/usr/bin/env bash

SUFFIX_REGEX=$1
FILE_PATH=$2

if [ "$SUFFIX_REGEX" = "" ]
then
    echo "** Please input Suffix Regex ***"
    exit 1
fi

API_BUILD_RESULT=$($FILE_PATH/gradlew -p $FILE_PATH dependencies --configuration api)
IMPLEMENTATION_BUILD_RESULT=$($FILE_PATH/gradlew -p $FILE_PATH dependencies --configuration implementation)
BUILD_RESULT="$API_BUILD_RESULT \n $IMPLEMENTATION_BUILD_RESULT"

BUILD_SUCCESSFUL_COUNT=$(echo -e "$BUILD_RESULT" | awk '/BUILD SUCCESSFUL/' | wc -l)
SNAPSHOT_DEPENDENCIES_COUNT=$(echo -e "$BUILD_RESULT" | awk '/'"$SUFFIX_REGEX"'/' | wc -l)

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n---\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo $(echo -e "$BUILD_RESULT" | awk '/'"$SUFFIX_REGEX"'/')
  exit 1
elif [ "$BUILD_SUCCESSFUL_COUNT" -lt "1" ]
then
  echo "Build failed, please check input params again. SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
  exit 1
else
  printf "*** No snapshot dependencies! *** \n"
fi