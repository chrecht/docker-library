#!/bin/bash
set -e

. ./functions.sh

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("node-red")


#####################
### node-red
#####################

for i in "${!REGISTRY[@]}"
do

	BASEPATH=./node-red/4.0.5
	ver_major=4
	ver_minor=0
	ver_patch=5
	buildAndPush ${BASEPATH}/Dockerfile ${BASEPATH}/ test ${ver_major}.${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}

	BASEPATH=./node-red/flowfuse-2.9.0-4.0.x
	ver_major=4
	ver_minor=0
	ver_patch=x
	buildAndPush ${BASEPATH}/Dockerfile ${BASEPATH}/ flowfuse-2.9.0 ${ver_major}.${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
done

exit