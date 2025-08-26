#!/bin/bash


code_dir="$HOME/code"

if [[ ! -d "$code_dir" ]]; then
  echo "  Creating code directory at $code_dir…"
  mkdir -p "$code_dir"
else
  echo " Code directory already exists at $code_dir."
fi
