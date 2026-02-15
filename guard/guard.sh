#!/bin/bash

# minimus guard - pre-commit safety check

show_help() {
    echo -e "\033[1;36mminimus guard\033[0m"
    echo "usage: ./guard.sh"
    echo ""
    echo "scans staged files for common mistakes (keys, large files)."
}

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
    exit 0
fi

ISSUE_COUNT=0

# ASCII Art
echo -e "\033[1;30m _ __ ___  _ _ __ (_)_ __ ___  _   _ ___ "
echo -e "\033[0;37m| '_ \` _ \| | '_ \| | '_ \` _ \| | | / __|"
echo -e "\033[1;37m| | | | | | | | | | | | | | | | |_| \__ \\"
echo -e "\033[1;36m|_| |_| |_|_|_| |_|_|_| |_| |_|\__,_|___/\033[0m"
echo -e "\033[1;36mminimus guard: $(pwd)\033[0m"
echo ""

if ! command -v git &> /dev/null; then
    echo -e "  \033[1;31m[!] git not found\033[0m"
    exit 1
fi

echo -e "  \033[1;30m[>] scanning staged files...\033[0m"

STAGED_FILES=$(git diff --cached --name-only)

if [ -z "$STAGED_FILES" ]; then
    echo -e "  \033[1;32m[+] no staged files\033[0m"
    exit 0
fi

MAX_SIZE=$((50 * 1024 * 1024)) # 50MB

for file in $STAGED_FILES; do
    if [ ! -f "$file" ]; then continue; fi

    # 1. Check Forbidden Files
    if [[ "$file" == *".env"* || "$file" == *"node_modules"* || "$file" == *"venv"* || "$file" == *".DS_Store"* || "$file" == *"id_rsa"* || "$file" == *"id_ed25519"* ]]; then
        echo -e "  \033[1;31m[!] forbidden file: $file\033[0m"
        ((ISSUE_COUNT++))
    fi

    # 2. Check File Size
    SIZE=$(stat -c%s "$file" 2>/dev/null || stat -f%z "$file" 2>/dev/null)
    if [ "$SIZE" -gt "$MAX_SIZE" ]; then
        MB_SIZE=$((SIZE / 1024 / 1024))
        echo -e "  \033[1;31m[!] large file (${MB_SIZE} MB): $file\033[0m"
        ((ISSUE_COUNT++))
    fi

    # 3. Scan Content for Secrets (only text files < 1MB)
    if [ "$SIZE" -lt 1048576 ]; then
        # Simple grep scan (binary files might cause issues, ignore binary matches)
        if grep -qE "AKIA[0-9A-Z]{16}|-----BEGIN PRIVATE KEY-----|-----BEGIN RSA PRIVATE KEY-----|sk_live_[0-9a-zA-Z]{24}|ghp_[0-9a-zA-Z]{36}" "$file"; then
             echo -e "  \033[1;31m[!] potential secret detected in: $file\033[0m"
             ((ISSUE_COUNT++))
        fi
    fi
done

if [ "$ISSUE_COUNT" -gt 0 ]; then
    echo ""
    echo -e "  \033[1;31m[!] $ISSUE_COUNT issues found. fix before committing.\033[0m"
    exit 1
else
    echo -e "  \033[1;32m[+] all clear\033[0m"
    exit 0
fi
