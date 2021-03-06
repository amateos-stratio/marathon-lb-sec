#!/bin/bash -e
BASEDIR=$( cd "$(dirname "$0")" ; pwd -P )/..

cd $BASEDIR

if [[ -z "$1" ]]; then
	VERSION=$(cat $BASEDIR/VERSION)
else
	VERSION=$1
fi

docker build . -t "stratio/marathon-lb-sec:$VERSION"
