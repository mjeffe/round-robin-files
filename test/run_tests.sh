#!/bin/bash

export PATH=".:../:$PATH"

. helpers.sh

_is_in_path rrin
_is_in_path rrout

_runtest() {
    t="$1"
    _say "running test $t"
    $t
    _chkerr $? "$t"
}

_runtest t1.sh
_runtest t2.sh
_runtest t3.sh
_runtest t4.sh
