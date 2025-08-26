#!/bin/bash

if ! command -v rustup >/dev/null 2>&1; then
  echo "  Installing Rust (rustup)…"
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo " Rust (rustup) already installed."
fi
