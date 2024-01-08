

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
		--pull \
		--push \
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
    
	if [ -f ${BASEPATH}/.current ]; then
    	current=$(cat ${BASEPATH}/.current)
	else
		current=""
	fi

    [[ ${latest} = ${current} ]]

}
