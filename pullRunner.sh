#!/bin/bash
set -ex
BASE_DIR="$(cd -P "$(dirname "$BASH_SOURCE")" && pwd -P)"
cd "${BASE_DIR}"

. /home/tools/init.sh

ECR="${ACCOUNT_ID}.dkr.ecr.${REGION}.amazonaws.com"

aws ecr get-login-password | docker login --username AWS --password-stdin ${ECR}

docker pull --quiet ${ECR}/develop/dga-selenium-runner:latest
docker tag ${ECR}/develop/dga-selenium-runner:latest dga-selenium-runner:latest
