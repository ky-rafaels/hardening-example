#!/bin/bash

set -ux

MIRROR=""
REPO=registry1.dso.mil
IMAGE=ironbank/opensource/keycloak/keycloak
TAG=26.0.0

IMAGE_PATH=${MIRROR}/${REPO}/${IMAGE}:${TAG}

BUILD_DATE=$(date -I)

echo "
------

Pulling image and beginning in place patching...

------"

docker pull --platform linux/amd64 ${IMAGE_PATH}

trivy image --pkg-types os --platform linux/amd64 --ignore-unfixed -f json -o ../trivy/keycloak-${TAG}.json ${IMAGE_PATH}

## Optionally you can create and use your own builder uncommenting the section below
# export BUILDKIT_VERSION=master
# docker run \
#     --detach \
#     --rm \
#     --privileged \
#     --platform linux/amd64 \
#     --name buildkitd \
#     --entrypoint buildkitd \
#     "moby/buildkit:$BUILDKIT_VERSION"

copa patch -i ${IMAGE_PATH} --debug -r ../trivy/keycloak-${TAG}.json -t ${TAG}-patched --addr docker://desktop-linux

docker build -t ${IMAGE_PATH}-${BUILD_DATE}-patched --provenance=true --sbom=true --builder=desktop-linux ../

# Sign image with cosign 

# Build an SBOM and associate with image

# Push to registry