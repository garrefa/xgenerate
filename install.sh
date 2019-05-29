#!/usr/bin/env bash

SCRIPT_PATH=`greadlink -f ${BASH_SOURCE[0]} | xargs dirname`
cp -R $SCRIPT_PATH /usr/local/share/xgenerate
ln -s $SCRIPT_PATH/bin/xgenerate /usr/local/bin
