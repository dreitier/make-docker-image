# make-docker-image
Builds and pushes Docker image with help of a simple `Makefile`. For fast, local testing. Not more, not less.

# Prerequisites
This scripts expects that you use the following directory structure in your Git repository:

```bash
    src/                    <-- root directory for Dockerfiles and stuff
        flavor/             <-- directory with flavors - you do not need it if no flavors are used
            grails-2.5.6/   <-- one flavor
                Dockerfile
                .excluded_from_shared_changes   <-- flavor is ignored if anything changes in src/shared
            grails-6.0.0/   <-- another flavor
                Dockerfile
            grails-7.0.7/   <-- and another flavor
                Dockerfile
        entrypoint.sh       <-- any other shared file can be on top of src/ ...
        shared/             <-- .. or in any sub directory
            command.sh
        Dockerfile          <-- if you do not use any flavor, Dockerfile must be at src/Dockerfile
```

# Installation

Link `Makefile` in your Git repository with Docker images:
```bash
# switch over to your repository
cd your-docker-image-repo

# add this repository
git submodule add https://github.com/dreitier/make-docker-image
git commit -am 'ci: make-docker-image'

# create config
touch default.config
```

After that, add the following to `default.config`:

```bash
REGISTRY_AWS_ECR := some-ecr-id.dkr.ecr.eu-central-1.amazonaws.com
REGISTRY_LOCAL := localhost:5000
REPOSITORY := your-repository
IMAGE_NAME := your-image-name
# pass some arguments to your Docker image when using `make run` or `make interactive`
# DOCKER_ARGS := -p 5432:5432
```

In your Docker image 

# When cloning your Docker image repository
Execute `make-docker-image/setup/setup.sh` to download the `make-docker-image` submodule.

# Usage

```bash
# detect any changes in directory src/*
make detect-last-changed-flavors
# 1. if changes in src/flavor/grails-2.5.6/Dockerfile have been made: 
grails-2.5.6
# 2. if multiple changes are made made in src/flavor/grails-2.5.6 and grails-6.0.0 have been made:
grails-2.5.6
grails-6.0.0
# 3. if any change in src/* (not flavor/ but e.g. src/entrypoint.sh) has been made, only non-excluded flavors are affected:
grails-6.0.0
grails-7.0.7
# 4. grails-2.5.6 is ignored because marker file .excluded_from_shared_changes is present in that flavor

# git-tag this repository with the given tag
make git-tag ${TAG}

# git-tag this repository, push tag and current branch to origin
make git-release ${TAG}

# deleted local git tag and remote git tag
make git-revoke ${TAG}

# list your git refs (short hash, referenced tag pointing to checked out commit)
make list-git-refs
# outputs:
# 2ae08fb 1.0.0

# build your Docker image locally
make build
# build a flavor
FLAVOR=grails-2.5.6 make build

# build your Docker image and push it to the specified AWS ECR location. Latest git tag is used.
make push-ecr

# build your Docker image and push it to the local location. Latest git tag is used.
make push-local 
# or just `make push`
# build and push a flavor
FLAVOR=grails-2.5.6 make push-local

# clean docker image
make clean

# run image
make run

# run image with interactive shell
make interactive
```
