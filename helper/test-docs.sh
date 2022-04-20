#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

readonly CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly REPO_ROOT_DIR=$(cd "${CURRENT_DIR}/../" && pwd)
source "${REPO_ROOT_DIR}/helper/lib/test.sh" || { echo 'Cannot load test tools.'; exit 1; }

if [ $# -ne 0 ]; then 
    test::test_docker_kvm "$1" "$2"
else
    find "${REPO_ROOT_DIR}/tests/docs" -type f -name '*.sh' -print0 | while read -d $'\0' file
    do
        IMAGE="$(platform::get_image_name $file)"
        test::test_docker_kvm "$IMAGE" "${file##"$REPO_ROOT_DIR"/}"
    done
fi
