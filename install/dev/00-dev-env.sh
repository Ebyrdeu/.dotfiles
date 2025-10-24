#!/bin/bash

# Install mise if missing
if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl https://mise.run | sh
    source ~/.bashrc
else
    echo "mise is already installed."
fi

# Install Node.js
echo "Installing Node.js..."
mise use --global node@lts
echo "Node.js installed: $(node -v)"

# Install npm
echo "Installing npm..."
mise use --global npm
echo "npm installed: $(npm -v)"

# Install pnpm
echo "Installing pnpm..."
mise use --global pnpm
echo "pnpm installed: $(pnpm -v)"

# Install Go
echo "Installing Go..."
mise use --global go@latest
echo "Go installed: $(go version)"

# Install Zig
echo "Installing Zig..."
mise use --global zig@latest
echo "Zig installed: $(zig version)"

# Install Java
echo "Installing Java..."
mise use --global java@oracle-graalvm
echo "Java installed: $(java --version)"

# Install Maven
echo "Installing Maven..."
mise use --global maven@latest
echo "Maven installed: $(mvn --version)"

# Install Gradle
echo "Installing Gradle..."
mise use --global gradle@latest
echo "Gradle installed: $(gradle --version)"

# Install Rust
echo "Installing Rust..."
mise use --global rust@latest
echo "Rust installed: $(cargo --version)"