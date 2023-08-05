#!/bin/bash

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/nginx")


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
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR} \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}-${VARIANT} \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}-${VARIANT} \
		-f ${DOCKERFILE} --progress=plain ${CONTEXT}

}

function build()
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
		--pull \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}-${VARIANT} \
		-t ${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}-${VARIANT} \
		-f ${DOCKERFILE} --progress=plain ${CONTEXT}

}


BASEPATH=./nginx


for i in "${!REGISTRY[@]}"
do
	buildAndPush ${BASEPATH}/1.25/Dockerfile ${BASEPATH}/1.25 mainline 1.25 1 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	buildAndPush ${BASEPATH}/1.24/Dockerfile ${BASEPATH}/1.24 stable 1.24 0 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	buildAndPush ${BASEPATH}/1.23/Dockerfile ${BASEPATH}/1.23 old 1.23 4 ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
done
