#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

source "${REPO_ROOT_DIR}/helper/lib/init.sh" || { echo 'Cannot initialize shared library.'; exit 1; }
source "${REPO_ROOT_DIR}/helper/lib/platform.sh" || { echo 'Cannot initialize platform library.'; exit 1; }

test::run() {
    echo "#!/usr/bin/env bash"  > /run.sh
    echo "set -x"               >> /run.sh
    echo "set -o nounset"       >> /run.sh
    echo "set -o errexit"       >> /run.sh

    for i in "$@"; do
        local -n value="$i"
        echo "value: $value"
        echo "# Script: $i"                             >> /run.sh
        grep '$ ' <<< "$value" | sed 's/^\s*\$\s*//'    >> /run.sh
        echo "# Done Script: $i"                        >> /run.sh
    done
    echo "Instructions:"
    batcat /run.sh
    chmod a+rx /run.sh
    sudo --preserve-env=DEBIAN_FRONTEND,TZ -i -u $USERNAME -n /run.sh
}


test::test_docker_kvm()
{
    local IMAGE="$1"
    local SCRIPT_REL_PATH="$2"
    local USER="user"
    local CONTAINER_HOME="/home/user"
    local TIMESTAMP="$(date +"%Y_%m_%dT%H_%M%z")"
    local WORKDIR="/src"

    local LOCAL_CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
    local LOCAL_REPO_ROOT_DIR=$(cd "${LOCAL_CURRENT_DIR}/../../" && pwd)

    echo "Using image: $IMAGE"
    echo "Running tests for: $SCRIPT_REL_PATH"

    docker pull "$IMAGE"
    docker run --rm --name enarxdoctest-$TIMESTAMP \
        --privileged \
        --device /dev/kvm \
        -v "$LOCAL_REPO_ROOT_DIR":/src:ro \
        -e DEBIAN_FRONTEND=noninteractive \
        -e TZ=UTC \
        -w "$WORKDIR" \
        "$IMAGE" \
        "$SCRIPT_REL_PATH"
} 