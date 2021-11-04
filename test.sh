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
  set +e
  docker rm --force ${NAME} >/dev/null 2>&1
  docker rm --force selenium-runner >/dev/null 2>&1
  docker rm --force selenium-firefox >/dev/null 2>&1
  docker rm --force selenium-chrome >/dev/null 2>&1
  set -e
}

cleanUp

trap 'cleanUp' EXIT

rm -rf .output
mkdir -p .output
chmod ugo+rwx .output

docker run --name ${NAME} -d --network host --shm-size="2g" selenium/standalone-${BROWSER}

# Turn off echo so dots work.
set +x

endSeconds=$((SECONDS + 120))
until $(curl --output /dev/null --silent --head --fail "127.0.0.1:4444"); do
  printf '.'
  sleep 1
  if [[ $SECONDS -gt ${endSeconds} ]]; then
    echo "Timed out waiting for the selenium to start"
    docker logs ${NAME}
    exit 1
  fi
done
set -x

sleep 1

docker run --rm --network host --name selenium-runner \
  -v $(pwd)/sides:/home/selenium/sides \
  -v $(pwd)/.output:/home/selenium/output \
  dga-selenium-runner:latest \
  --browser ${BROWSER} \
  --base-url ${BASE_URL}
