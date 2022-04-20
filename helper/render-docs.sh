#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

readonly CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly REPO_ROOT_DIR=$(cd "${CURRENT_DIR}/../" && pwd)
source "${REPO_ROOT_DIR}/helper/lib/render.sh" || { echo 'Cannot load render tools.'; exit 1; }

init::initialize_block_vars

if [ $# -eq 0 ]; then 
    dest_prefix="$(render::destination_prefix)"
else 
    dest_prefix=$1
fi

# Render
find "${REPO_ROOT_DIR}/docs/templates" -type f -name '*.tpl' -print0 | while read -d $'\0' file
do
    destination="$(render::get_destination_path $file $dest_prefix)"
    echo "Rendering $file to $destination"
    render::render_template "$file" "$destination"
done

echo "Done!"