

function buildAndPush()
{

    DOCKERFILE=$1
    CONTEXT=$2
    VARIANT=$3
    MAJOR=$4
    MINOR=$5
	PATCH=$6

	REGISTRY=$7
	REPOPATH=$8
	REPOIMAGE=$9

	if [ -z "${VARIANT}" ];
	then
		TAG1=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}
		TAG2=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}
		TAG3=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}.${PATCH}
	else
		TAG1=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}-${VARIANT}
		TAG2=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}-${VARIANT}
		TAG3=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}.${PATCH}-${VARIANT}
	fi

	docker buildx build \
		--platform=linux/amd64 \
		--pull \
		--push \
		-t ${TAG1} \
		-t ${TAG2} \
		-t ${TAG3} \
		-f ${DOCKERFILE} --progress=plain ${CONTEXT}

}

function build()
{

    DOCKERFILE=$1
    CONTEXT=$2
    VARIANT=$3
    MAJOR=$4
    MINOR=$5
	PATCH=$6

	REGISTRY=$7
	REPOPATH=$8
	REPOIMAGE=$9

	if [ -z "${VARIANT}" ];
	then
		TAG1=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}
		TAG2=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}
		TAG3=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}.${PATCH}
	else
		TAG1=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}-${VARIANT}
		TAG2=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}-${VARIANT}
		TAG3=${REGISTRY}/${REPOPATH}/${REPOIMAGE}:${MAJOR}.${MINOR}.${PATCH}-${VARIANT}
	fi

	docker buildx build \
		--platform=linux/amd64 \
		--pull \
		-t ${TAG1} \
		-t ${TAG2} \
		-t ${TAG3} \
		-f ${DOCKERFILE} --progress=plain ${CONTEXT}

}


get_latest_nginx_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl -s "https://hub.docker.com/v2/repositories/library/nginx/tags?page_size=100&name=${SEARCH_MAJOR}." | jq -r '.results|.[]|.name' | grep -Ei "^(${SEARCH_MAJOR}.[0-9]+)$" | head -1)
	
	ver_major=$(echo $latest | sed -En 's/^([0-9]+)\.[0-9]+\.[0-9]+/\1/p')
	ver_minor=$(echo $latest | sed -En 's/^[0-9]+\.([0-9]+)\.[0-9]+/\1/p')
	ver_patch=$(echo $latest | sed -En 's/^[0-9]+\.[0-9]+\.([0-9]+)/\1/p')

}

get_latest_php_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php${SEARCH_MAJOR}-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

	ver_major=$(echo $latest | sed -En 's/^([0-9]+)\.[0-9]+\.[0-9]+/\1/p')
	ver_minor=$(echo $latest | sed -En 's/^[0-9]+\.([0-9]+)\.[0-9]+/\1/p')
	ver_patch=$(echo $latest | sed -En 's/^[0-9]+\.[0-9]+\.([0-9]+)/\1/p')

}

get_latest_node_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl -s "https://hub.docker.com/v2/repositories/library/node/tags?page_size=100&name=${SEARCH_MAJOR}." | jq -r '.results|.[]|.name' | grep -Ei "^(${SEARCH_MAJOR}.[0-9]+.[0-9]+)$" | head -1)
	
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
