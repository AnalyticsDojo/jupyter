#!/bin/bash
set -euo pipefail
# Used by travis to trigger deployments or builds
# Keeping this here rather than make travis.yml too complex

ACTION="${1}"
PUSH=''
if [[ ${ACTION} == 'build' ]]; then
    if [[ ${TRAVIS_PULL_REQUEST} == 'false' ]]; then
        PUSH='--push'
        # Assume we're in master and have secrets!
        docker login -u $DOCKER_USERNAME -p "$DOCKER_PASSWORD"
    fi

    ./deploy.py build --commit-range ${TRAVIS_COMMIT_RANGE} ${PUSH}
elif [[ ${ACTION} == 'deploy' ]]; then
    echo "Starting deploy..."
    REPO="https://github.com/${TRAVIS_REPO_SLUG}"
    CHECKOUT_DIR="/tmp/${TRAVIS_BUILD_NUMBER}"
    COMMIT="${TRAVIS_COMMIT}"
    MASTER_HOST="datahub-fa17-${TRAVIS_BRANCH}.westus2.cloudapp.azure.com"
fi
