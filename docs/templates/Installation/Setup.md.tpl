# Initial Setup

## Install Dependencies

Please find instructions for each Linux distribution below:

### Fedora

${BLOCK_fedora_setup}

### CentOS 8 / Stream

${BLOCK_centos8_setup}

:::note

You may want to add that final `source` command to a `~/.profile`,
`~/.bashrc` / or `~/.bash_profile` equivalent, otherwise you must remember
to source that file prior to building `enarx`.

:::

### CentOS 7 / Scientific Linux 7 and other clones

${BLOCK_centos7_step1}

or search for the package on https://centos.pkgs.org/ and install it manually with, for example:

    $ sudo yum install http://mirror.centos.org/centos/7/extras/x86_64/Packages/centos-release-scl-rh-2-3.el7.centos.noarch.rpm

and then:

${BLOCK_centos7_step2}


:::note

You may want to add that final `source` command to a `~/.profile`,
`~/.bashrc` / or `~/.bash_profile` equivalent, otherwise you must remember
to source that file prior to building `enarx`.

Instead of `devtoolset-9` you can choose `devtoolset-10` or later versions.

:::

### Debian / Ubuntu

${BLOCK_debian_setup}


:::tip

The minimum required `gcc` version is version 9. Something older _might_ build
binaries (such as integration test binaries), but may silently drop required
compiler flags. Please ensure you're using the minimum required version of `gcc`.
Failure to do so might result in weird failures at runtime.

:::

## Install Rust

${BLOCK_rust_install}