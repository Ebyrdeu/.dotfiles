#!/usr/bin/env bash

# Cleanup script for Arch Linux using Paru
# Includes orphan removal, dependency cleanup, and cache management

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Remove orphan packages
clean_orphans() {
    echo -e "${YELLOW}Checking for orphan packages...${NC}"
    mapfile -t orphans < <(pacman -Qtdq 2>/dev/null || true)

    if (( ${#orphans[@]} )); then
        echo -e "${RED}Found orphan packages:${NC}"
        printf '%s\n' "${orphans[@]}"
        echo
        sudo pacman -Rns --noconfirm "${orphans[@]}"
        echo -e "${GREEN}Orphan packages removed!${NC}"
    else
        echo -e "${GREEN}No orphan packages found.${NC}"
    fi
}

# Clean unnecessary dependencies
clean_dependencies() {
    echo -e "${YELLOW}Cleaning unnecessary dependencies...${NC}"
    mapfile -t deps < <(pacman -Qdttq 2>/dev/null || true)

    if (( ${#deps[@]} )); then
        echo -e "${RED}Found unnecessary dependencies:${NC}"
        printf '%s\n' "${deps[@]}"
        echo
        sudo pacman -Rns --noconfirm "${deps[@]}"
        echo -e "${GREEN}Unnecessary dependencies removed!${NC}"
    else
        echo -e "${GREEN}No unnecessary dependencies found.${NC}"
    fi
}

# Clean package cache
clean_cache() {
    echo -e "${YELLOW}Cleaning package cache...${NC}"
    paru -Sc --noconfirm
    echo -e "${GREEN}Package cache cleaned!${NC}"
    echo
    read -r -p "Do you also want to deep clean all cached packages? (removes ALL) [y/N]: " ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
        paru -Scc --noconfirm
        echo -e "${GREEN}Deep cache clean complete!${NC}"
    fi
}

# Clean all
clean_all() {
    clean_orphans
    clean_dependencies
    clean_cache
}

# Menu
main_menu() {
    echo -e "\n${GREEN}Arch Linux Cleanup Script (Paru)${NC}"
    echo "1. Remove orphan packages"
    echo "2. Clean unnecessary dependencies"
    echo "3. Clean package cache"
    echo "4. Clean all (orphans + dependencies + cache) [default]"
    echo "5. Exit"

    read -r -p "Enter your choice [1-5]: " choice

    # Default to Clean All if empty input
    if [[ -z "$choice" ]]; then
        echo -e "${YELLOW}No choice entered. Running Clean All...${NC}"
        clean_all
        return
    fi

    case $choice in
        1) clean_orphans ;;
        2) clean_dependencies ;;
        3) clean_cache ;;
        4) clean_all ;;
        5) exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; main_menu ;;
    esac
}

# Check paru
if ! command -v paru &>/dev/null; then
    echo -e "${RED}Error: paru is not installed. Please install paru first.${NC}"
    exit 1
fi

# Warn if root
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Warning: Running as root is not recommended.${NC}"
    read -r -p "Continue anyway? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

main_menu
