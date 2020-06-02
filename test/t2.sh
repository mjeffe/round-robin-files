#!/bin/bash

#
# verify that slow-process ran on each record output by rrout
#

src=bigfile.txt
out=t2_final.txt

. helpers.sh

_cleanup() {
    rm -f source1 source2 source3 out1 out2 out3 $out
}
_check_result() {
    local result=`grep -v '^foo ' out1 out2 out3`
    if [ -n "$result" ]; then
        echo "output records are not prepended by the sring 'foo'"
        exit 1
    fi
}

_cleanup

# make fifos
mkfifo source1 source2 source3

# start round robining the big file to fifios
rrout $src source1 source2 source3 &

# start the slow process reading from fifos and writing to output fifos
slow-process < source1 > out1 &
slow-process < source2 > out2 &
slow-process < source3 > out3 &

wait

_check_result

_cleanup
