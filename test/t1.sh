#!/bin/bash

#
# run both rrout and rrin to recreate the input file
#

src=bigfile.txt
out=t1_final.txt

_cleanup() {
    rm -f source1 source2 source3 out1 out2 out3 $out
}
_check_result() {
    local result=`diff $src $out`
    if [ -n "$result" ]; then
        echo "result differs from input"
        exit 1
    fi
}

_cleanup

# make fifos
mkfifo source1 source2 source3
mkfifo out1 out2 out3

# start round robining the big file to fifios
rrout $src source1 source2 source3 &

# start the slow process reading from fifos and writing to output fifos
do-nothing-process < source1 > out1 &
do-nothing-process < source2 > out2 &
do-nothing-process < source3 > out3 &

# merge back to a single output file
rrin out1 out2 out3 > $out
wait

_check_result

_cleanup
