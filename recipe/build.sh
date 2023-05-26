#!/bin/bash
# *****************************************************************
# (C) Copyright IBM Corp. 2018, 2023. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************
set -ex

source open-ce-common-utils.sh

SCRIPT_DIR=$RECIPE_DIR/../buildscripts

# Pick up additional variables defined from the conda build environment
$SCRIPT_DIR/set_python_path_for_bazelrc.sh $SRC_DIR
export BAZEL_LINKLIBS=-l%:libstdc++.a

bazel --bazelrc=${SRC_DIR}/python_configure.bazelrc build --copt=O3 :pip_pkg

#build a whl file
mkdir -p $SRC_DIR/tensorflow_probability_pkg
bazel-bin/pip_pkg $SRC_DIR/tensorflow_probability_pkg --release

# install using pip
pip install --no-deps $SRC_DIR/tensorflow_probability_pkg/*.whl

PID=$(bazel info server_pid)
echo "PID: $PID"
cleanup_bazel $PID
