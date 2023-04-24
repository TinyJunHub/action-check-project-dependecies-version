#!/usr/bin/env bash

SUFFIX_REGEX=$1
FILE_PATH=$2

if [[ "$SUFFIX_REGEX" == "" ]]
then
    echo "** Please input Suffix Regex ***"
    exit 1
fi

BUILD_SUCCESSFUL_COUNT=$($FILE_PATH/gradlew -p $FILE_PATH :app:dependencies --configuration api | awk '/BUILD SUCCESSFUL/' | wc -l)

API_SNAPSHOT_DEPENDENCIES_COUNT=$($FILE_PATH/gradlew -p $FILE_PATH :app:dependencies --configuration api | awk '/'"$SUFFIX_REGEX"'/' | wc -l)
IMPLEMENTATION_SNAPSHOT_DEPENDENCIES_COUNT=$($FILE_PATH/gradlew -p $FILE_PATH :app:dependencies --configuration implementation | awk '/'"$SUFFIX_REGEX"'/' | wc -l)
SNAPSHOT_DEPENDENCIES_COUNT=`expr $API_SNAPSHOT_DEPENDENCIES_COUNT + $IMPLEMENTATION_SNAPSHOT_DEPENDENCIES_COUNT`

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n---\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo $($FILE_PATH/gradlew -p $FILE_PATH :app:dependencies --configuration api | awk '/'"$SUFFIX_REGEX"'/')
  echo $($FILE_PATH/gradlew -p $FILE_PATH :app:dependencies --configuration implementation | awk '/'"$SUFFIX_REGEX"'/')
  exit 1
elif [ "$BUILD_SUCCESSFUL_COUNT" -ne "1" ]
then
  echo "Build failed, please check input params again. SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
  exit 1
fi