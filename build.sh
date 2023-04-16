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


get_latest_php_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php${SEARCH_MAJOR}-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

	ver_major=$(echo $latest | sed -En 's/^([0-9]+)\.[0-9]+\.[0-9]+/\1/p')
	ver_minor=$(echo $latest | sed -En 's/^[0-9]+\.([0-9]+)\.[0-9]+/\1/p')
	ver_patch=$(echo $latest | sed -En 's/^[0-9]+\.[0-9]+\.([0-9]+)/\1/p')

}

is_latest() {
    
    current=$(cat ${BASEPATH}/.current)

    [[ ${latest} = ${current} ]]

}


#####################
### php-8.2
#####################

BASEPATH=./php/8.2

get_latest_php_version 8.2

echo "Latest PHP Version: ${latest}"

if is_latest; then
	
	echo "Already lastest version; do nothing"

else 

	echo ${latest} > ${BASEPATH}/.current

    git add ${BASEPATH}/.current
    git commit -F - <<EOF
    Bump PHP version to ${latest}

    https://www.php.net/ChangeLog-8.php#${latest}
EOF

	for i in "${!REGISTRY[@]}"
	do
		buildAndPush ${BASEPATH}/apache/Dockerfile ${BASEPATH}/apache apache ${ver_major}.${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
		buildAndPush ${BASEPATH}/cli/Dockerfile ${BASEPATH}/cli cli ${ver_major}.${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
		buildAndPush ${BASEPATH}/fpm/Dockerfile ${BASEPATH}/fpm fpm ${ver_major}.${ver_minor} ${ver_patch} ${REGISTRY[$i]} ${REPOPATH[$i]} ${REPOIMAGE[$i]}
	done

fi

exit 0
