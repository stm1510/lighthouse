#!/usr/bin/env bash

##
# @license Copyright 2021 The Lighthouse Authors. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
##

# Prints to stdout text that, when it changes, indicates that the devtools tests
# should rebuild the devtools frontend.

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LH_ROOT="$SCRIPT_DIR/../.."

unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     machine=Linux;;
  Darwin*)    machine=Mac;;
  MINGW*)     machine=MinGw;;
  *)          machine="UNKNOWN:${unameOut}"
esac

cd "$LH_ROOT"
bash .github/scripts/print-devtools-relevant-commits.sh

if [ "$machine" == "Linux" ]; then
  hash_command=md5sum
elif [ "$machine" == "Mac" ]; then
  hash_command=md5
else
  echo "unsupported platform"
  exit 1
fi

$hash_command \
  lighthouse-core/test/devtools-tests/* \
  third-party/devtools-tests/e2e/**/*.*
