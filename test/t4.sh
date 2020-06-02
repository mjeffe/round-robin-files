#!/bin/bash

#
# test that rrin generates an output file with records in the correct order,
# given a known set of input files.
#

src=bigfile.txt
out=t4_final.txt

. helpers.sh

_cleanup() {
    rm -f out1 out2 out3 $out
}
_check_result() {
    local result=`diff $src $out`
    if [ -n "$result" ]; then
        echo "result appear in the output file in an unexpected order"
        exit 1
    fi
}

_cleanup

# generate our input files
rrout $src out1 out2 out3

# combine them with rrin - this should recreate our input
rrin out1 out2 out3 > $out

_check_result "$result"

_cleanup
