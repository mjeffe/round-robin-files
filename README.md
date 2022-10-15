# round-robin-files
A set of utilities for reading and writing parallel file streams.

## !!!! USE AT YOUR OWN RISK !!!!
This code is useful to me so I'm making it available to others, but I make no guarantees whatsoever.

These are utilities I've used as part of large data processing jobs on Unix
systems. The two main programs `rrin` and `rrout` simply read and write
records from/to multiple files to/from a single file. These are pure C
code, so should compile for you without any trouble.

## Compile

You should simply be able to run
```
make
make test
```

Then copy `rrin` and `rrout` to somewhere in your path (`~/bin/` for example)

## Usage

`rrout` reads records from an input file (or stdin) and distributes them (in
round robin order) to multiple output files.

`rrin` reads one record at a time from multiple input files (in round robin
order) and writes the combined output to stdout.

I use these utilities in shell scripts, reading and writing to named pipes.
This allows me to set up parallel pipelines on some particularly slow process.
Here is a generic example (with error checking or other production necessary
code removed for clarity).

    #!/bin/bash

    _cleanup() {
        rm -f source1 source2 source3 out1 out2 out3
    }

    _cleanup

    # make fifos
    mkfifo source1 source2 source3
    mkfifo out1 out2 out3

    # start round robining the big file to fifios
    rrout bigfile.txt source1 source2 source3 &

    # start the slow process reading from fifos and writing to output fifos
    slow-process < source1 > out1 &
    slow-process < source2 > out2 &
    slow-process < source3 > out3 &

    # merge back to a single output file
    rrin out1 out2 out3 > final.dat
    wait

    _cleanup
