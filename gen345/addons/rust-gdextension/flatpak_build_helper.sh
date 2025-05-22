#!/bin/sh

. "$HOME/.cargo/env"

cargo build
cargo build --release