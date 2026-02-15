#!/bin/bash

# minimus installer for Linux/macOS

INSTALL_DIR="$HOME/.minimus/bin"
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# new ASCII Art
echo -e "\033[1;30m _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ "
echo -e "\033[0;37m| '_ \` _ \| | '_ \| | '_ \` _ \| | | / __|"
echo -e "\033[1;37m| | | | | | | | | | | | | | | | |_| \__ \\"
echo -e "\033[1;36m|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/\033[0m"
echo -e "\033[1;36minstalling minimus...\033[0m"

mkdir -p "$INSTALL_DIR"

TOOLS=("bootstrap" "cleanall" "score" "readme" "guard" "doctor" "depsize")

for tool in "${TOOLS[@]}"; do
    # Try different locations
    if [ -f "$BASE_DIR/$tool.sh" ]; then
        SOURCE="$BASE_DIR/$tool.sh"
    elif [ -f "$BASE_DIR/$tool/$tool.sh" ]; then
        SOURCE="$BASE_DIR/$tool/$tool.sh"
    else
        echo -e "\033[1;31m[!] could not find $tool.sh\033[0m"
        continue
    fi

    cp "$SOURCE" "$INSTALL_DIR/$tool"
    chmod +x "$INSTALL_DIR/$tool"
    echo -e "\033[1;32m[+] installed $tool\033[0m"
done

# Check PATH
if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    echo -e "\033[1;33m[!] Action Required:\033[0m"
    echo "add the following line to your shell config (.bashrc, .zshrc, etc.):"
    echo ""
    echo "  export PATH=\"\$HOME/.minimus/bin:\$PATH\""
    echo ""
else
    echo -e "\033[1;32m[+] $INSTALL_DIR is already in your path\033[0m"
fi

echo -e "\033[1;36minstallation complete!\033[0m"
