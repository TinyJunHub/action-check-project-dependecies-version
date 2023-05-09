#!/usr/bin/env bash

SUFFIX_REGEX=$1
FILE_PATH=$2
SUBPROJECT_NAME=$3

if [ "$SUFFIX_REGEX" = "" ]
then
    echo "** Please input Suffix Regex ***"
    exit 1
fi

GET_ALL_DEPENDENCIES_COMMAND="dependencies"
if [ "$SUBPROJECT_NAME" != "" ]
then
  GET_ALL_DEPENDENCIES_COMMAND=":$SUBPROJECT_NAME:$GET_ALL_DEPENDENCIES_COMMAND"
fi

echo "*** Start to check the dependencies ***"

echo "*** run command : $FILE_PATH/gradlew -p $FILE_PATH $GET_ALL_DEPENDENCIES_COMMAND --configuration api***"
API_DEPENDENCIES_RESULT=$($FILE_PATH/gradlew -p $FILE_PATH $GET_ALL_DEPENDENCIES_COMMAND --configuration api)
echo "*** run command : $FILE_PATH/gradlew -p $FILE_PATH $GET_ALL_DEPENDENCIES_COMMAND --configuration implementation ***"
IMPLEMENTATION_DEPENDENCIES_RESULT=$($FILE_PATH/gradlew -p $FILE_PATH $GET_ALL_DEPENDENCIES_COMMAND --configuration implementation)

DEPENDENCIES_RESULT="$API_DEPENDENCIES_RESULT \n $IMPLEMENTATION_DEPENDENCIES_RESULT"

BUILD_SUCCESSFUL_COUNT=$(echo -e "$DEPENDENCIES_RESULT" | grep "BUILD SUCCESSFUL" | wc -l)
SNAPSHOT_DEPENDENCIES_RESULT=$(echo -e "$DEPENDENCIES_RESULT" | grep "$SUFFIX_REGEX")

SNAPSHOT_DEPENDENCIES_COUNT=0
if [ "$SNAPSHOT_DEPENDENCIES_RESULT" != "" ]
then
  SNAPSHOT_DEPENDENCIES_COUNT=$(echo -e "$SNAPSHOT_DEPENDENCIES_RESULT" | wc -l)
fi

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo "$SNAPSHOT_DEPENDENCIES_RESULT"
  echo "*** End to check the dependencies ***"
  exit 1
elif [ "$BUILD_SUCCESSFUL_COUNT" -lt "1" ]
then
  echo "Build failed, please check input params again. SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
  echo "*** End to check the dependencies ***"
  exit 1
else
  echo "*** End to check the dependencies ***"
fi