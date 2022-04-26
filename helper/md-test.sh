#!/usr/bin/env bash

set -eu

readonly IMAGES=( registry.gitlab.com/enarx/misc-testing/ubuntu-base:latest
                  registry.gitlab.com/enarx/misc-testing/debian-base:latest
                  registry.gitlab.com/enarx/misc-testing/centos7-base:latest
                  registry.gitlab.com/enarx/misc-testing/centos8-base:latest
                  registry.gitlab.com/enarx/misc-testing/fedora-base:latest )
readonly CONTEXTS_NON_KVM=( git,helloworld crates,helloworld ) 
readonly CONTEXTS_KVM=( git,helloworld,kvm-helloworld,kvm crates,helloworld,kvm-helloworld,kvm ) 
# readonly CONTEXTS_SGX=( sgx,git,helloworld,sgx-helloworld sgx,crates,helloworld,sgx-helloworld ) 
# readonly CONTEXTS_SNP=( snp,git,helloworld,kvm-helloworld,kvm snp,crates,helloworld,kvm-helloworld,kvm ) 
readonly HOMEDIR="/home/user"

test_image_kvm() {
    local markdown_doc_path="$(realpath "$1")"
    local image="$2"
    local context="$3"
    echo -e "\n\nRunning: ${image} (KVM)"
    echo "Context: \"${context}\""
    echo "Markdown Document: \"${markdown_doc_path}\""
    docker run \
        --rm \
        --device /dev/kvm --privileged \
        -v "${markdown_doc_path}":"$HOMEDIR/Install.md":ro \
        -e CONTEXT="${context}" "${image}"
    status=$?
    if [[ $status -eq 0 ]]; then
        echo -e "Run with ${image} (KVM) and context \"${context}\" suceeded!\n\n"
    else
        echo "Run with ${image} (KVM) and context \"${context}\" failed!" | tee /dev/stderr
        exit $status
    fi
}

test_image_basic() {
    local markdown_doc_path="$(realpath "$1")"
    local image="$2"
    local context="$3"
    echo -e "\n\nRunning: ${image}"
    echo "Context: \"${context}\""
    echo "Markdown Document: \"${markdown_doc_path}\""
    docker run \
        --rm \
        -v "${markdown_doc_path}":"$HOMEDIR/Install.md":ro \
        -e CONTEXT="${context}" "${image}"
    status=$?
    if [[ $status -eq 0 ]]; then
        echo -e "Run with ${image} and context \"${context}\" suceeded!\n\n"
    else
        echo "Run with ${image} and context \"${context}\" failed!" | tee /dev/stderr
        exit $status
    fi
}

alias_function () {
    local ORIG_FUNC=$(declare -f $1)
    local NEWNAME_FUNC="$2${ORIG_FUNC#$1}"
    eval "$NEWNAME_FUNC"
}

MODE=${MODE:-"basic"}
if [[ "$MODE" == "kvm" ]]; then
    contexts=("${CONTEXTS_KVM[@]}")
    alias_function test_image_kvm test_image
else
    contexts=("${CONTEXTS_NON_KVM[@]}")
    alias_function test_image_basic test_image
fi

markdown_document="$1"
echo "Markdown Document: ${markdown_document}" 
echo "Contexts:"
for i in "${contexts[@]}"; do echo "    - $i"; done 
echo "Images:"
for i in "${IMAGES[@]}"; do echo "    - $i"; done 

for context in "${contexts[@]}"; do
    for image in "${IMAGES[@]}"; do
        test_image "${markdown_document}" "${image}"  "${context}"
    done
done

echo "Testing completed!"
