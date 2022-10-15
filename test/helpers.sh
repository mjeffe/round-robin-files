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

# ---------------------------------------------------------------------------
_is_in_path() {
    which "$1" > /dev/null 2>&1
    rc=$?
    if [ $rc -ne 0 ]; then
        echo "unable to find $1 in path, do you need to run 'make'?"
        exit 1
    fi
}
