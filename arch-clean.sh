#!/usr/bin/env bash

# Cleanup script for Arch Linux using Yay
# Includes orphan removal, dependency cleanup, and cache management

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to remove orphan packages
clean_orphans() {
    echo -e "${YELLOW}Checking for orphan packages...${NC}"
    orphans=$(pacman -Qtdq)
    
    if [[ -n "$orphans" ]]; then
        echo -e "${RED}Found orphan packages:${NC}"
        echo "$orphans"
        echo
        sudo pacman -Rns --noconfirm $orphans
        echo -e "${GREEN}Orphan packages removed!${NC}"
    else
        echo -e "${GREEN}No orphan packages found.${NC}"
    fi
}

# Function to clean unnecessary dependencies
clean_dependencies() {
    echo -e "${YELLOW}Cleaning unnecessary dependencies...${NC}"
    deps=$(pacman -Qdttq)
    
    if [[ -n "$deps" ]]; then
        echo -e "${RED}Found unnecessary dependencies:${NC}"
        echo "$deps"
        echo
        sudo pacman -Rns --noconfirm $deps
        echo -e "${GREEN}Unnecessary dependencies removed!${NC}"
    else
        echo -e "${GREEN}No unnecessary dependencies found.${NC}"
    fi
}

# Function to clean package cache
clean_cache() {
    echo -e "${YELLOW}Cleaning package cache...${NC}"
    yay -Sc --noconfirm
    echo -e "${GREEN}Package cache cleaned!${NC}"
}

# Function to clean all (orphans + dependencies + cache)
clean_all() {
    clean_orphans
    clean_dependencies
    clean_cache
}

# Main menu
main_menu() {
    echo -e "\n${GREEN}Arch Linux Cleanup Script${NC}"
    echo "1. Remove orphan packages"
    echo "2. Clean unnecessary dependencies"
    echo "3. Clean package cache"
    echo "4. Clean all (orphans + dependencies + cache)"
    echo "5. Exit"
    
    read -p "Enter your choice [1-5]: " choice
    
    case $choice in
        1) clean_orphans ;;
        2) clean_dependencies ;;
        3) clean_cache ;;
        4) clean_all ;;
        5) exit 0 ;;
        *) echo -e "${RED}Invalid option!${NC}"; main_menu ;;
    esac
}

# Check if yay is installed
if ! command -v yay &> /dev/null; then
    echo -e "${RED}Error: yay is not installed. Please install yay first.${NC}"
    exit 1
fi

# Check for root privileges
if [[ $EUID -eq 0 ]]; then
    echo -e "${RED}Warning: Running as root is not recommended.${NC}"
    read -p "Continue anyway? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] || exit 1
fi

# Start the script
main_menu
