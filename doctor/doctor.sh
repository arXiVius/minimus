#!/bin/bash

# minimus doctor - system and project health check

show_help() {
    echo -e "\033[1;36mminimus doctor\033[0m"
    echo "usage: ./doctor.sh"
    echo ""
    echo "checks system tools and project health."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# ASCII Art
echo -e "\033[1;30m _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ "
echo -e "\033[0;37m| '_ \` _ \| | '_ \| | '_ \` _ \| | | / __|"
echo -e "\033[1;37m| | | | | | | | | | | | | | | | |_| \__ \\"
echo -e "\033[1;36m|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/\033[0m"
echo -e "\033[1;36mminimus doctor\033[0m"
echo ""

echo -e "  \033[1;30m[>] checking system tools...\033[0m"

TOOLS=("git" "node" "npm" "python3" "pip3" "docker" "cargo" "go" "code")

for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
        VERSION=$($tool --version 2>/dev/null | head -n 1)
        if [ -z "$VERSION" ]; then VERSION="detected"; fi
        # truncate if too long
        if [ ${#VERSION} -gt 50 ]; then VERSION="${VERSION:0:50}..."; fi
        echo -e "  \033[1;32m[+] $tool found ($VERSION)\033[0m"
    else
        echo -e "  \033[1;31m[!] $tool not found\033[0m"
    fi
done

echo ""
echo -e "  \033[1;30m[>] checking project health...\033[0m"

if [ -f "package.json" ]; then
    if [ ! -d "node_modules" ]; then
        echo -e "  \033[1;33m[?] package.json detected but no node_modules found. run 'minimus bootstrap' or 'npm install'.\033[0m"
    else
        echo -e "  \033[1;32m[+] node project seems healthy\033[0m"
    fi
fi

if [ -f "requirements.txt" ]; then
    if [[ ! -d "venv" && ! -d ".venv" ]]; then
        echo -e "  \033[1;33m[?] requirements.txt detected but no venv found. run 'minimus bootstrap'.\033[0m"
    else
        echo -e "  \033[1;32m[+] python project seems healthy\033[0m"
    fi
fi

echo ""
echo -e "  \033[1;36m[+] diagnosis complete\033[0m"
