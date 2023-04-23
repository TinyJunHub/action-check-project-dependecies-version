#!/usr/bin/env bash

SUFFIX_REGEX=$1

if [ "$SUFFIX_REGEX" == "" ]
then
    echo "** Please input Suffix Regex ***"
    exit 1
fi

API_SNAPSHOT_DEPENDENCIES_COUNT=$(./gradlew :app:dependencies --configuration api | awk '/'"$SUFFIX_REGEX"'/' | wc -l)
IMPLEMENTATION_SNAPSHOT_DEPENDENCIES_COUNT=$(./gradlew :app:dependencies --configuration implementation | awk '/'"$SUFFIX_REGEX"'/' | wc -l)
SNAPSHOT_DEPENDENCIES_COUNT=`expr $API_SNAPSHOT_DEPENDENCIES_COUNT + $IMPLEMENTATION_SNAPSHOT_DEPENDENCIES_COUNT`

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n---\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo $(./gradlew :app:dependencies --configuration api | awk '/'"$SUFFIX_REGEX"'/')
  echo $(./gradlew :app:dependencies --configuration implementation | awk '/'"$SUFFIX_REGEX"'/')
  exit 1
elif [ "$SNAPSHOT_DEPENDENCIES_COUNT" != "0" ]
then
  echo "SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
  exit 1
else
  echo "SNAPSHOT_DEPENDENCIES_COUNT: $SNAPSHOT_DEPENDENCIES_COUNT"
fi