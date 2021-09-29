#!/bin/bash
set -ex
BASE_DIR="$(cd -P "$(dirname "$BASH_SOURCE")" && pwd -P)"
cd "${BASE_DIR}"

BROWSER="firefox"
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
  -b | --browser)
    shift # past argument
    BROWSER="$1"
    ;;
  --base-url)
    shift # past argument
    BASE_URL="$1"
    ;;    
  *)
    echo "Invalid option $1"
    exit 1
    ;;
  esac

  shift
done

if [[ -z "${BASE_URL}" ]]; then
  echo "--base-url mandatory"
  exit 1
fi

NAME="selenium-${BROWSER}"

function cleanUp() {
  docker rm --force selenium-runner || true
  docker rm --force ${NAME} || true
}

cleanUp

trap 'cleanUp' EXIT

rm -rf .output
mkdir -p .output
chmod ugo+rwx .output

docker run --name ${NAME} -d --network host --shm-size="2g" selenium/standalone-${BROWSER}
sleep 5

docker run --rm --network host --name selenium-runner \
  -v $(pwd)/sides:/home/selenium/sides \
  -v $(pwd)/.output:/home/selenium/output \
  dga-selenium-runner:latest \
  --browser ${BROWSER} \
  --base-url ${BASE_URL}
