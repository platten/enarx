#!/usr/bin/env bash

set -o nounset
set -o errexit
set -E

readonly CURRENT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
readonly REPO_ROOT_DIR=$(cd "${CURRENT_DIR}/../../" && pwd)
source "${REPO_ROOT_DIR}/helper/lib/test.sh" || { echo 'Cannot load test tools.'; exit 1; }
source "${REPO_ROOT_DIR}/helper/lib/platform.sh" || { echo 'Cannot load platform tools.'; exit 1; }

init::initialize_block_vars

platform::debian_setup
test::run \
    BLOCK_debian_setup \
    BLOCK_rust_install \
    BLOCK_install_enarx_cratesio \
    BLOCK_backend_info \
    BLOCK_install_wasm_toolchain \
    BLOCK_create_wasm_program \
    BLOCK_run_wasm_program
