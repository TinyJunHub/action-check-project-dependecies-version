#!/usr/bin/env bash

SUFFIX_REGEX=$1
if [ "$SUFFIX_REGEX" == "" ]; then
    echo "** Please input Suffix Regex ***"
    exit 1
fi
SNAPSHOT_DEPENDENCIES_COUNT=$(mvn dependency:tree -Dscope=compile -Dincludes=:::\*$SUFFIX_REGEX | awk '/'"$SUFFIX_REGEX"'/' | wc -l)

if [ "$SNAPSHOT_DEPENDENCIES_COUNT" -gt "0" ]
then
  printf "*** %s SNAPSHOT dependencies detected ***\n---\n" "$SNAPSHOT_DEPENDENCIES_COUNT"
  echo $(mvn dependency:tree -Dscope=compile -Dincludes=:::\*$SUFFIX_REGEX | awk '/'"$SUFFIX_REGEX"'/')
  exit 1
fi