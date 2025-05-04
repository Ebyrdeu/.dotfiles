#!/bin/bash
 
packages=(
# Core tools
"base-devel"
"cmake"
"go"

# Terminal & CLI
"alacritty"
"fd"
"fzf"
"ripgrep"
"tmux"
"tldr"

# Containers
"docker"
"docker-buildx"
"docker-compose"
)

# Directory for code projects
code_dir="$HOME/code"

# Function to check if a package is installed via pacman
is_installed_pacman() {
    pacman -Qi $1 > /dev/null 2>&1
}

# Function to check if a package is installed via yay (AUR)
is_installed_yay() {
    yay -Qs $1 > /dev/null 2>&1
}

# Function to install a package using pacman
install_package_pacman() {
    echo "Installing $1 from official repositories..."
    sudo pacman -S --noconfirm $1
}

# Function to install a package using yay (AUR)
install_package_yay() {
    echo "Installing $1 from AUR..."
    yay -S --noconfirm $1
}

# Function to install SDKMAN
install_sdkman() {
    if [ ! -d "$HOME/.sdkman" ]; then
        echo "Installing SDKMAN..."
        curl -s "https://get.sdkman.io" | bash
    else
        echo "SDKMAN is already installed."
    fi
}

# Function to install Rust using rustup
install_rust() {
    if ! command -v rustup &> /dev/null; then
        echo "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    else
        echo "Rust is already installed."
    fi
}

# Function to create code directory if it doesn't exist
create_code_directory() {
    if [ ! -d "$code_dir" ]; then
        echo "Creating code directory at $code_dir..."
        mkdir -p $code_dir
    else
        echo "Code directory already exists at $code_dir."
    fi
}

# Loop through the list of packages and install if not already installed
for package in "${packages[@]}"; do
    if is_installed_pacman $package || is_installed_yay $package; then
        echo "[$package] is already installed."
    else
        if pacman -Si $package > /dev/null 2>&1; then
            install_package_pacman $package
        else
            install_package_yay $package
        fi
        echo "$package ---- 完全"
    fi
done

# Function to configure Docker permissions
configure_docker() {
    if ! grep -qE '^docker:' /etc/group; then
        echo "Creating docker group..."
        sudo groupadd docker
    fi

    if ! groups $USER | grep -q '\bdocker\b'; then
        echo "Adding $USER to docker group..."
        sudo usermod -aG docker $USER
        echo "NOTE: You'll need to log out and back in for group changes to take effect!"
    fi

    echo "Enabling Docker service..."
    sudo systemctl enable --now docker.service
    sudo systemctl enable --now docker.socket
}

configure_sim_link_idea() {
if [ -d "/opt/idea" ]; then
    # Check if the idea binary exists in the expected location
    if [ -f "/opt/idea/bin/idea" ]; then
        # Create symbolic link
        sudo ln -s /opt/idea/bin/idea /usr/local/bin/idea
        echo "Symbolic link created successfully: /usr/local/bin/idea → /opt/idea/bin/idea"
    else
        echo "Error: /opt/idea/bin/idea not found. Is IntelliJ IDEA installed correctly?"
        exit 1
    fi
else
    echo "Error: /opt/idea directory not found. IntelliJ IDEA might not be installed."
    exit 1
fi
}

# Install SDKMAN
install_sdkman

# Install Rust
install_rust

# Create code directory
create_code_directory

 
# Configure Docker permissions and service
configure_docker


# Configure Idea sim link for hyprland startup
configure_sim_link_idea

echo "Done"
