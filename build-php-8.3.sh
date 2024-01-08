#!/bin/bash
set -e

. ./functions.sh

REGISTRY=("ghcr.io")
REPOPATH=("chrecht")
REPOIMAGE=("docker-library/php")


#####################
### php-8.3
#####################

BASEPATH=./php/8.3

get_latest_php_version 8.3

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
