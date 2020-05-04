#!/bin/bash

pub get || exit $

EXIT_CODE=0
dartfmt -n --set-exit-if-changed . || EXIT_CODE=$?
echo "dartfmt exit with ${EXIT_CODE}"
dartanalyzer --fatal-infos --fatal-warnings . || EXIT_CODE=$?
echo "dartanalyzer exit with ${EXIT_CODE}"

exit $EXIT_CODE