#!/bin/bash

#
# test that rrout puts the correct records in the correct file. That is, verify
# that it is reading and writing in a round robin scheme
#

src=bigfile.txt
out=t3_final.txt

. helpers.sh

_cleanup() {
    rm -f out1 out2 out3 $out
}
_check_result() {
    if [ -n "$1" ]; then
        echo "result has unexpected record in output file"
        exit 1
    fi
}

_cleanup

rrout $src out1 out2 out3

result=`cat out1 | grep -v 'line 1' | grep -v 'line 4'`
_check_result "$result"

result=`cat out2 | grep -v 'line 2' | grep -v 'line 5'`
_check_result "$result"

result=`cat out3 | grep -v 'line 3'`
_check_result "$result"

_cleanup
