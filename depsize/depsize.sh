#!/bin/bash

# minimus depsize - dependency size analyzer

show_help() {
    echo -e "\033[1;36mminimus depsize\033[0m"
    echo "usage: ./depsize.sh"
    echo ""
    echo "shows size of dependencies in node_modules or venv."
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
echo -e "\033[1;36mminimus depsize\033[0m"
echo ""

TARGET_DIR=""

if [ -d "node_modules" ]; then
    TARGET_DIR="node_modules"
    echo -e "  \033[1;30m[>] analyzing node_modules...\033[0m"
elif [ -d "venv/lib" ]; then
    # Find python version directory
    SITE_PACKAGES=$(find venv/lib -name "site-packages" -type d | head -n 1)
    if [ -n "$SITE_PACKAGES" ]; then
        TARGET_DIR="$SITE_PACKAGES"
        echo -e "  \033[1;30m[>] analyzing venv...\033[0m"
    fi
elif [ -d ".venv/lib" ]; then
     # Find python version directory
    SITE_PACKAGES=$(find .venv/lib -name "site-packages" -type d | head -n 1)
    if [ -n "$SITE_PACKAGES" ]; then
        TARGET_DIR="$SITE_PACKAGES"
         echo -e "  \033[1;30m[>] analyzing .venv...\033[0m"
    fi
fi

if [ -z "$TARGET_DIR" ]; then
    echo -e "  \033[1;33m[?] no supported dependency directory found (node_modules, venv)\033[0m"
    exit 0
fi

# du -sh * | sort -hr | head -n 10
# We need to filter out files and only show directories if possible, or just standard du usage
# Note: output formatting is tricky to perfectly match PS1 without logic, but `du` is standard.

cd "$TARGET_DIR" || exit
du -sh * 2>/dev/null | sort -hr | head -n 10 | while read -r line; do
    echo -e "  $line"
done

# Total
echo ""
TOTAL=$(du -sh . 2>/dev/null | cut -f1)
echo -e "  \033[1;36mtotal: $TOTAL\033[0m"
echo ""
