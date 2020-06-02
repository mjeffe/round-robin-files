#!/bin/bash

export PATH=".:../:$PATH"

. helpers.sh

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
