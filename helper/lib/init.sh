#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

init::initialize_block_vars() {
    local codeblock_file=$(mktemp)
    find "${REPO_ROOT_DIR}/docs/scripts" -type f -name '*.block' -print0 | while read -d $'\0' file
    do
        echo "Including $file"
        cat "$file" >> "${codeblock_file}"
    done
    source "$codeblock_file"
    rm "$codeblock_file"
}
