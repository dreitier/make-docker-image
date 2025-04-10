#!/bin/bash
PWD=`pwd`
MAKE_DOCKER_IMAGE_DIRECTORY=make-docker-image
MAKEFILE_SHARED=Makefile.shared

if [ ! -e $PWD/Makefile ]; then
	echo "[info] No Makefile available in current directory, setting it up..."

	# local development of make-docker-image
	if [ -d $PWD/../$MAKE_DOCKER_IMAGE_DIRECTORY ]; then
		echo "[info] ../${MAKE_DOCKER_IMAGE_DIRECTORY} repository is available, using this one."
		ln -s $PWD/../$MAKE_DOCKER_IMAGE_DIRECTORY/$MAKEFILE_SHARED $PWD/Makefile 
	# submodule
	elif [ ! -d $PWD/$MAKE_DOCKER_IMAGE_DIRECTORY/$MAKEFILE_SHARED ]; then
		echo "[info] Git submodule ${MAKE_DOCKER_IMAGE_DIRECTORY} has not been checked out yet. Cloning submodule..."
		git submodule init

		ln -s $PWD/$MAKE_DOCKER_IMAGE_DIRECTORY/$MAKEFILE_SHARED $PWD/Makefile 
	else
		echo "[warn] I have *no* idea how to set up the Makefile. Either use ../${MAKE_DOCKER_IMAGE_DIRECTORY} for local development or use the 'git submodule' method"
	fi
else
	echo "[info] Makefile already linked :-)"
fi

if [ -e $PWD/$MAKE_DOCKER_IMAGE_DIRECTORY/$MAKEFILE_SHARED ]; then
	echo "[info] Updating make-docker-image ... "
	git submodule update
fi

if [ ! -e $PWD/Makefile ]; then
	echo "[error] Could not link Makefile in this directory to any of the options!"
	exit 1
fi
