# Installing Enarx

You can install Enarx from GitHub, crates.io, or Nix.

    
## Install from GitHub

${BLOCK_install_enarx_git}

## Install from crates.io

:::note

Rust version ${RUST_TOOLCHAIN} is required when installing Enarx ${ENARX_VERSION} from crates.io.

:::

${BLOCK_install_enarx_cratesio}



## Install from Nix

Users with `nix` package manager installed (see https://nixos.org) should be able to just do in the checked out repository:

${BLOCK_install_nix_setup}


```sh
${BLOCK_install_nix_stable}
```
(on legacy, stable `nix` installs)

or:
```sh
${BLOCK_install_nix_latest}
```

:::note

`nix-shell` opens file descriptors `3` and `4` and the enarx `cargo test` fails therefore. `nix develop` does not seem to have this problem.

:::
