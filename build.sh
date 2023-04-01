#!/bin/bash

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/php")

function buildAndPush()
{

    DOCKERFILE=$1
    CONTEXT=$2
    VARIANT=$3
    MAJOR=$4
    MINOR=$5

	docker buildx build \
		--platform=linux/amd64 \
		--push \
		--pull \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}-${VARIANT} \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}-${VARIANT} \
		-f ${DOCKERFILE} --progress=plain ${CONTEXT}

}



for i in "${!REGISTRY[@]}"
do
    
    buildAndPush ./php/8.2/Dockerfile-apache ./php/8.2/ apache 8.2 4
	buildAndPush ./php/8.2/Dockerfile-cli ./php/8.2/ cli 8.2 4

done
