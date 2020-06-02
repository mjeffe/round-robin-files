#!/bin/bash

# ---------------------------------------------------------------------------
_say() {
    #local dt=`date | perl -ne 'chomp; print'`
    #echo "$dt: $1"
    echo "$1"
}
# ---------------------------------------------------------------------------
_chkerr() {
    if [ $1 -ne 0 ]; then
        _say "TEST FAILED: $2 exited with error (rc=$1)"
        echo
    fi
}

