#!/bin/bash

DIR="$( cd "$(dirname ${BASH_SOURCE[0]})"; pwd -P )"
pushd . > /dev/null
cd $DIR

docker build -t ib-gateway:latest .

echo 'Finished'

popd > /dev/null