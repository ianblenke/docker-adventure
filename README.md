## Colossal Cave Adventure

[Rick Adams](http://rickadams.org/adventure/e_downloads.html) has a great history of the versions of Adventure.

This docker image is built from the Adventure 6 version, using f2c and the fortran source.

From the original README upon which this docker image is built:

    `Generic Adventure 551' is a cleaned up and enhanced version of the
    old classic text game `Adventure'. It is based on a version close to the
    seriously non-portable (and buggy) version for Primes posted last spring. I
    have done a fair job of cleaning it up, portabilizing it, and debugging, but
    it is still Fortran spaghetti. For you with no Fortran compilers, this is the
    excuse you need to get "f2c" working!!! It has worked on the IBM-PC, VMS, the
    MIPS 120, the IBM RISCstation 600, the VAX/Ultrix, and a Prime. It will
    however expose toy Fortran compilers as just that - toys. I would like to
    thank Larry Estep for finding some hidden bugs.

    For those that have not experienced this, the very first text adventure game,
    it is a romp through the darkest reaches of Colossal Cave in search of
    riches. You will find evocative descriptions of the darker, more mysterious
    places of the earth, and severely test your abilities to map the
    contortions of the cave. You will find some hard - and some deceptively
    easy - puzzles to solve.
    
    Doug McDonald

Builder this docker image like so:

	docker build -t ianblenke/adventure .

Passing any command to this image will run the docker container interactively:

	docker run -ti --rm -p 3000:3000 ianblenke/adventure adventure

Alternatively, run this docker container with a wetty tty web interface in the background:

	docker run -d --name adventure -p 3000:3000 ianblenke/adventure

Now open a web browser to `http://{your docker host}:3000/`
