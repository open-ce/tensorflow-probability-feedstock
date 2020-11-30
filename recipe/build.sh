# *****************************************************************
#
# Licensed Materials - Property of IBM
#
# (C) Copyright IBM Corp. 2018, 2020. All Rights Reserved.
#
# US Government Users Restricted Rights - Use, duplication or
# disclosure restricted by GSA ADP Schedule Contract with IBM Corp.
#
# *****************************************************************
#!/bin/bash
set -ex

SCRIPT_DIR=$RECIPE_DIR/../buildscripts

# Pick up additional variables defined from the conda build environment
$SCRIPT_DIR/set_python_path_for_bazelrc.sh $SRC_DIR

bazel --bazelrc=${SRC_DIR}/python_configure.bazelrc build --copt=O3 :pip_pkg

#build a whl file
mkdir -p $SRC_DIR/tensorflow_probability_pkg
bazel-bin/pip_pkg $SRC_DIR/tensorflow_probability_pkg --release

# install using pip
pip install --no-deps $SRC_DIR/tensorflow_probability_pkg/*.whl

bazel clean --expunge
bazel shutdown
