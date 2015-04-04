#!/bin/bash
NAME="erp_test@127.0.0.1"
SYNC="executable notification_center"
START="config auto_test"
COOKIE="erp_test"
CMD="erl -pa deps/*/ebin ebin tests/ebin -setcookie $COOKIE -name $NAME -sync $SYNC -s $START"

$CMD
