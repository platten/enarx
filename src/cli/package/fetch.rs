// SPDX-License-Identifier: Apache-2.0

use clap::Args;

/// Download a local copy of a package.
#[derive(Args, Debug)]
pub struct Options {}

impl Options {
    pub fn execute(self) -> anyhow::Result<()> {
        unimplemented!()
    }
}
