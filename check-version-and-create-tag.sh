#!/bin/bash
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

get_latest_php_version()
{

	SEARCH_MAJOR=$1

	latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php${SEARCH_MAJOR}-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

	MAJOR=$(echo $latest | sed -En 's/^([0-9]+)\.[0-9]+\.[0-9]+/\1/p')
	MINOR=$(echo $latest | sed -En 's/^[0-9]+\.([0-9]+)\.[0-9]+/\1/p')
	PATCH=$(echo $latest | sed -En 's/^[0-9]+\.[0-9]+\.([0-9]+)/\1/p')

}

is_latest() {

	SEARCH_MAJOR=$1

    current=$(cat php/${SEARCH_MAJOR}/.env)

    [[ ${latest} = ${current} ]]

}


get_latest_php_version 8.2

if is_latest 8.2; then

	echo "Version is up to date"

else

	echo $latest > php/8.2/.current
	echo "" > php/8.2/.env
	echo "export MAJOR=${MAJOR}" >> php/8.2/.env
	echo "export MINOR=${MINOR}" >> php/8.2/.env
	echo "export PATCH=${PATCH}" >> php/8.2/.env


    BRANCH_NAME="update-${CI_PROJECT_NAME}-${CI_PIPELINE_ID}"
    git config user.email "${GITLAB_USER_EMAIL}"
    git config user.name "${GITLAB_USER_NAME}"
    git checkout -b "${BRANCH_NAME}"
    git add php/8.2/.current
	git add php/8.2/.env
    git commit -F - <<EOF
    Bump PHP version to ${latest}

    https://www.php.net/ChangeLog-8.php#${latest}
EOF

    git remote remove origin
    git remote add origin git@${CI_SERVER_HOST}:$CI_PROJECT_PATH.git
    git tag -a ${MAJOR}.${MINOR}.${PATCH} -m "Version created by gitlab-ci"
    git push origin ${MAJOR}.${MINOR}.${PATCH}


fi
