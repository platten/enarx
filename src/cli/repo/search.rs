// SPDX-License-Identifier: Apache-2.0

use clap::Args;

/// Search for repositories that match a given query.
#[derive(Args, Debug)]
pub struct Options {}

impl Options {
    pub fn execute(self) -> anyhow::Result<()> {
        unimplemented!()
    }
}
