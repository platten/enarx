#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

source "${CURRENT_DIR}/lib/init.sh" || { echo 'Cannot initialize shared library.'; exit 1; }

export readonly VAR_RUST_TOOLCHAIN=$(cat rust-toolchain.toml |  sed -n 's/^channel = "\(.\+\)"/\1/p')
export readonly VAR_ENARX_VERSION=$(cat Cargo.toml | sed -n 's/^version = "\(.\+\)"/\1/p')


render::destination_prefix() {
    tag="$(git describe --exact-match HEAD  2> /dev/null)"
    if [ $? -eq 0 ]; then
       echo "$tag"
    else
        echo "main"
    fi
}

render::get_destination_path() {
    local source="$1"
    local dest_prefix="$2"
    echo $source | sed "s/docs\/templates\//docs\/rendered\/${dest_prefix}\//g" | cut -f1,2 -d'.'
}

render::render_template() {
    local source="$1"
    local destination="$2"

    mkdir -p "${destination%/*}"
    cat "$source" | envsubst | sed -e 's/§/$/g' > "$destination"
}
