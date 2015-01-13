CFLAGS:=-lf2c -lgfortran -lm -lc

all:
	@echo "Usage: make {build|run|compile}"
	@echo "   build - build the docker image
	@echo "	    run - run adventure interactively"
	@echo "     web - run adventure via web tty"
	@echo ""
	@echo " compile - compiles the source "(used by the build target)"
	@echo "    pull - downloads the source
	@echo " extract - unzips the source
	@echo "   clean - cleans the local directory

build:
	docker build -t ianblenke/adventure .

run:
	docker run -ti --rm --name adventure -p 3001:3000 ianblenke/adventure /adventure/adventure

web:
	docker run -ti --rm --name adventure -p 3001:3000 ianblenke/adventure

pull:
	wget http://www.ifarchive.org/if-archive/games/source/advsrc.zip

extract:
	unzip advsrc.zip

clean:
	rm advsrc.zip AAMAIN.FOR ADVDAT ADVENT.DOC ASETUP.FOR ASUBS.FOR IORS.FOR MAKEFILE README *.F *.FOR *.o *.c adventure asetup ADVDAT.orig ADVTXT || true

compile: asetup adventure ADVTXT

AAMAIN.F: AAMAIN.FOR
	cp $< $@

ASUBS.F: ASUBS.FOR
	cp $< $@

ASETUP.F: ASETUP.FOR
	cp $< $@

AAMAIN.c: AAMAIN.F
	f2c $<

ASUBS.c: ASUBS.F
	f2c $<

ASETUP.c: ASETUP.F
	f2c $<

extract:
	unzip 

asetup: extract ASETUP.c ASUBS.c
	gcc ${CFLAGS} -o $@ ASETUP.c ASUBS.c

adventure: AAMAIN.c ASUBS.c
	gcc ${CFLAGS} -o $@ AAMAIN.c ASUBS.c

ADVTXT: ADVDAT asetup
	if [ ! -f ADVDAT.orig ]; then cp ADVDAT ADVDAT.orig; tr -d '\015' < ADVDAT.orig > ADVDAT ; fi
	./asetup
