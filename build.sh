#!/bin/bash

DIR="$( cd "$(dirname ${BASH_SOURCE[0]})"; pwd -P )"
pushd . > /dev/null
cd $DIR

sudo docker-compose down
sudo docker rmi $(sudo docker images -f "dangling=true" -q)
sudo docker build -t ib-gateway:latest .

echo 'Finished'

popd > /dev/null