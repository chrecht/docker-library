#!/bin/bash
# Bash 'Strict Mode'
# http://redsymbol.net/articles/unofficial-bash-strict-mode
# https://github.com/xwmx/bash-boilerplate#bash-strict-mode
set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php8.2-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')

is_latest() {

    latest=$(curl --silent https://packages.sury.org/php/dists/bullseye/main/binary-amd64/Packages | grep "Package: php8.2-cli$" -A 5 | grep Version | sed -En  's/^Version: ([0-9]+\.[0-9]+\.[0-9]+).*/\1/p')
    current=$(cat .current)

    [[ ${latest} = ${current} ]]

}

if is_latest; then
    echo "Already lastest version; nothing to do."
else

    echo ${latest} > .current
    cat .current

    BRANCH_NAME="update-${CI_PROJECT_NAME}-${CI_PIPELINE_ID}"
    git checkout -b "${BRANCH_NAME}"
    git config user.email "${GITLAB_USER_EMAIL}"
    git config user.name "${GITLAB_USER_NAME}"

    git add .current
    git commit -F - <<EOF
    Bump PHP version to ${latest}

    https://www.php.net/ChangeLog-8.php#${latest}
EOF

    git remote remove origin
    git remote add origin https://oauth2:${GITLAB_ACCESS_TOKEN}@gitlab.waldbillig.io/containers/docker-library.git
    git pull --tags
    git tag -a $MAJOR.$MINOR -m "Version created by gitlab-ci Build"
    git push origin $MAJOR.$MINOR

fi


exit 0
