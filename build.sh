#!/bin/bash

REGISTRY=("registry.waldbillig.io" "ghcr.io")
REPOPATH=("containers" "chrecht")
REPOIMAGE=("docker-library/php" "docker-library/php")


function buildAndPush()
{

    DOCKERFILE=$1
    CONTEXT=$2
    VARIANT=$3
    MAJOR=$4
    MINOR=$5

	REGISTRY=$6
	REPOPATH=$7
	REPOIMAGE=$8

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
    
    buildAndPush ./php/8.2/Dockerfile-apache ./php/8.2/ apache 8.2 4 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	buildAndPush ./php/8.2/Dockerfile-cli ./php/8.2/ cli 8.2 4 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}

done
