#!/bin/bash
NAME="investor@127.0.0.1"
START="config auto_run"
COOKIE="hello_pippi"
CMD="erl -pa ebin deps/*/ebin -setcookie $COOKIE -name $NAME -s $START"

$CMD
