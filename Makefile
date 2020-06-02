#
# Note:
#   zfopen.c is part of James Lemley's jamestools
#
# $Id: Makefile 294 2016-10-24 15:47:33Z u35616872 $
#

MRJ = ..
TARGETS_ALL = rrin rrout
MAKEFLAGS = -i

# AIX Settings - you may have to run export OBJECT_MODE=64 or =32 before running make.
# (It may be possible to use the CFLAGS -q64 or -q32 and the LDFLAGS -b64 or -b32 instead)
# NOTE: splitval uses getopts which I can't find on AIX
CC_AIX = xlc
# IBM recommended optimization flags
AIX_OPTIMIZATIONS = -O3 -qstrict -qarch=pwr3 -qtune=pwr3
CFLAGS_AIX = $(AIX_OPTIMIZATIONS) -I. -D_LARGE_FILES -qcpluscmt -D_AIX_ 
#LDFLAGS_AIX = -b32 -bnoquiet
TARGETS_AIX = rrout rrvalue

# HPUX settings
CC_HPUX = /opt/aCC/bin/cc
#CC_HPUX = cc
CFLAGS_HPUX    = -O2 +DD64
CFLAGS_HPUX   += -D_UNIX_ -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_OPEN_SOURCE=500 -D_XOPEN_SOURCE_EXTENDED
LDFLAGS_HPUX   = +DD64
TARGETS_HPUX   = rrout rrvalue

#LINUX Settings
CC_LINUX = gcc
CFLAGS_LINUX   = -Wall -O2
#CFLAGS_LINUX   = -Wall -g -pg
#CFLAGS_LINUX  += -D_GNU_SOURCE
CFLAGS_LINUX  += -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64
# gprof flags - then call 'gprof <program> gmon.out'
#CFLAGS=-g3 -pg -I. -I$(SUPPORT) $(LINUX_LARGE_FILE_SUPPORT)
LDFLAGS_LINUX  = 
TARGETS_LINUX  = $(TARGETS_ALL)


# Set up variables depending on machine type
CC=$(CC_$(MAKE_MACHINE))
CFLAGS=$(CFLAGS_$(MAKE_MACHINE)) -I. -I$(MRJ)/include
#LDFLAGS2=$(LDFLAGS_$(MAKE_MACHINE)) -lm -lpthread
LDFLAGS2=$(LDFLAGS_$(MAKE_MACHINE)) -L$(MRJ)/support -L$(MRJ)/lib
TARGETS=$(TARGETS_$(MAKE_MACHINE))


all: check_make_machine $(TARGETS)

check_make_machine: 
	$(CHECK)

rrin: rrin.o
	$(CHECK)
	$(CC) $(CFLAGS) $(LDFLAGS2) -o rrin rrin.c

rrout: rrout.o
	$(CHECK)
	$(CC) $(CFLAGS) $(LDFLAGS2) -o rrout rrout.c

install:
	cp $(TARGETS) $(HOME)/bin/

.PHONY: clean
clean:
	rm -f *.o
	rm -f $(TARGETS)
	rm -f rrout_src.tar.gz

.PHONY: test
test:
	cd test && run_tests.sh


CHECK= \
  @if [ "$(MAKE_MACHINE)" = "" ]; \
  then \
     echo "MAKE_MACHINE not set: This must be set before running make."; \
     exit 1; \
  elif [ "$(MAKE_MACHINE)" = "AIX" -a "$(OBJECT_MODE)" = "" ]; \
  then \
     echo "Compiling on AIX and OBJECT_MODE is not set: This must be set before running make."; \
     exit 1; \
  fi

