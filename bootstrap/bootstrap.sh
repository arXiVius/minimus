#!/bin/bash

# minimus bootstrap - universal repo setup

show_help() {
    echo -e "\033[1;36mminimus bootstrap\033[0m"
    echo "usage: ./bootstrap.sh"
    echo ""
    echo "detects:"
    echo "  package.json      -> npm install"
    echo "  requirements.txt  -> venv + pip install"
    echo "  pyproject.toml    -> poetry install (or pip)"
    echo "  Cargo.toml        -> cargo build"
    echo "  go.mod            -> go mod tidy"
    echo "  Dockerfile        -> docker build"
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

# new ASCII Art
echo -e "\033[1;30m _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ "
echo -e "\033[0;37m| '_ \` _ \| | '_ \| | '_ \` _ \| | | / __|"
echo -e "\033[1;37m| | | | | | | | | | | | | | | | |_| \__ \\"
echo -e "\033[1;36m|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/\033[0m"
echo -e "\033[1;36mminimus bootstrap: $(pwd)\033[0m"
echo ""

if [ -f "package.json" ]; then
    echo -e "  \033[1;32m[+] node.js project detected\033[0m"
    if command -v npm &> /dev/null; then
        echo -e "  \033[0;37m[>] running 'npm install'...\033[0m"
        npm install
    else
        echo -e "  \033[1;31m[!] npm not found in path\033[0m"
    fi
elif [ -f "requirements.txt" ]; then
    echo -e "  \033[1;32m[+] python project detected (requirements.txt)\033[0m"
    echo -e "  \033[0;37m[>] creating venv...\033[0m"
    
    if ! command -v python3 &> /dev/null; then
        echo -e "  \033[1;31m[!] python3 not found in path\033[0m"
        exit 1
    fi

    python3 -m venv venv
    if [ -f "./venv/bin/pip" ]; then
        echo -e "  \033[0;37m[>] installing dependencies...\033[0m"
        ./venv/bin/pip install -r requirements.txt
    else
        echo -e "  \033[1;31m[!] failed to create venv or locate pip\033[0m"
    fi
elif [ -f "pyproject.toml" ]; then
    echo -e "  \033[1;32m[+] python project detected (pyproject.toml)\033[0m"
    if command -v poetry &> /dev/null; then
        echo -e "  \033[0;37m[>] found poetry. running 'poetry install'...\033[0m"
        poetry install
    else
        echo -e "  \033[1;33m[!] poetry not found. using pip to install current directory\033[0m"
        pip install .
    fi
elif [ -f "Cargo.toml" ]; then
    echo -e "  \033[1;32m[+] rust project detected\033[0m"
    if command -v cargo &> /dev/null; then
        echo -e "  \033[0;37m[>] running 'cargo build'...\033[0m"
        cargo build
    else
        echo -e "  \033[1;31m[!] cargo not found in path\033[0m"
    fi
elif [ -f "go.mod" ]; then
    echo -e "  \033[1;32m[+] go project detected\033[0m"
    if command -v go &> /dev/null; then
        echo -e "  \033[0;37m[>] running 'go mod tidy'...\033[0m"
        go mod tidy
    else
        echo -e "  \033[1;31m[!] go not found in path\033[0m"
    fi
elif [ -f "Dockerfile" ]; then
    echo -e "  \033[1;32m[+] docker project detected\033[0m"
     if command -v docker &> /dev/null; then
        echo -e "  \033[0;37m[>] building image...\033[0m"
        docker build -t .
    else
        echo -e "  \033[1;31m[!] docker not found in path\033[0m"
    fi
else
    echo -e "  \033[1;33m[?] no recognized project type found\033[0m"
    echo "      (checked for package.json, requirements.txt, Cargo.toml, etc.)"
fi
