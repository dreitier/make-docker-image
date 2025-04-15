# make-docker-image
Builds and pushes Docker image with help of a simple `Makefile`. For fast, local testing. Not more, not less.

# Installation

Link `Makefile` in your Docker image repository:
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

# When cloning your Docker image repository
Execute `make-docker-image/setup/setup.sh` to download the `make-docker-image` submodule.

# Usage

```bash
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

# build your Docker image and push it to the specified AWS ECR location. Latest git tag is used.
make push-ecr

# build your Docker image and push it to the local location. Latest git tag is used.
make push-local 
# or just `make push`

# clean docker image
make clean

# run image
make run

# run image with interactive shell
make interactive
```
