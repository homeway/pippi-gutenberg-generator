#!/bin/bash
NAME="mytest@127.0.0.1"
SYNC="executable notification_center"
START="config auto_test"
COOKIE="mytest"
CMD="erl -pa deps/*/ebin ebin tests/ebin -setcookie $COOKIE -name $NAME -sync $SYNC -s $START"

$CMD
