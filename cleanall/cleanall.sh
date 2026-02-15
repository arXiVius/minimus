#!/bin/bash

# minimus cleanall - universal project cleaner

show_help() {
    echo -e "\033[1;36mminimus cleanall\033[0m"
    echo "usage: ./cleanall.sh [-f/--force]"
    echo ""
    echo "removes: node_modules, venv, target, dist, build, coverage, __pycache__, .DS_Store"
}

FORCE=false

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

if [[ "$1" == "-f" || "$1" == "--force" ]]; then
    FORCE=true
fi

# new ASCII Art
echo -e "\033[1;30m _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ "
echo -e "\033[0;37m| '_ \` _ \| | '_ \| | '_ \` _ \| | | / __|"
echo -e "\033[1;37m| | | | | | | | | | | | | | | | |_| \__ \\"
echo -e "\033[1;36m|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/\033[0m"
echo -e "\033[1;36mminimus cleanall: $(pwd)\033[0m"
echo ""

TARGETS=("node_modules" "venv" ".venv" "target" "dist" "build" "coverage" "__pycache__" ".DS_Store")
FOUND=()

for target in "${TARGETS[@]}"; do
    if [ -e "$target" ]; then
        FOUND+=("$target")
    fi
done

if [ ${#FOUND[@]} -eq 0 ]; then
    echo -e "  \033[1;32m[+] nothing to clean\033[0m"
    exit 0
fi

echo -e "  \033[1;33m[?] found items to remove:\033[0m"
for item in "${FOUND[@]}"; do
    echo -e "    \033[1;31m- $item\033[0m"
done
echo ""

if [ "$FORCE" = false ]; then
    read -p "  are you sure you want to PERMANENTLY delete these items? (y/N) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "  \033[1;33m[!] aborted\033[0m"
        exit 1
    fi
fi

for item in "${FOUND[@]}"; do
    echo -n "  [>] removing $item... "
    rm -rf "$item"
    echo -e "\033[1;32mdone\033[0m"
done

echo ""
echo -e "  \033[1;36m[+] clean complete\033[0m"
