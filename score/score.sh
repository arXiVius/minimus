#!/bin/bash

# minimus score - project complexity scorer

show_help() {
    echo -e "\033[1;36mminimus score\033[0m"
    echo "usage: ./score.sh"
    echo ""
    echo "calculates code health score based on file count and loc."
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
echo -e "\033[1;36mminimus score: $(pwd)\033[0m"
echo ""

echo -e "  \033[1;30m[>] analyzing project...\033[0m"

EXCLUDES="--exclude-dir={node_modules,venv,.venv,target,dist,build,coverage,.git,.idea,.vscode}"

# count files
FILE_COUNT=$(find . -type f -not -path '*/node_modules/*' -not -path '*/venv/*' -not -path '*/.git/*' -not -path '*/target/*' -not -path '*/dist/*' | wc -l)

# count lines
LINE_COUNT=$(find . -type f -not -path '*/node_modules/*' -not -path '*/venv/*' -not -path '*/.git/*' -not -path '*/target/*' -not -path '*/dist/*' -exec wc -l {} + 2>/dev/null | awk '{sum += $1} END {print sum}')

if [ -z "$LINE_COUNT" ]; then LINE_COUNT=0; fi

# calculate score: files + (lines / 50)
SCORE=$((FILE_COUNT + (LINE_COUNT / 50)))

# Rating
RATING="Unknown"
COLOR="\033[1;37m"

if [ "$SCORE" -lt 10 ]; then
    RATING="tiny (micro)"
    COLOR="\033[1;36m" # Cyan
elif [ "$SCORE" -lt 50 ]; then
    RATING="small (mini)"
    COLOR="\033[1;32m" # Green
elif [ "$SCORE" -lt 200 ]; then
    RATING="medium (midi)"
    COLOR="\033[1;33m" # Yellow
elif [ "$SCORE" -lt 500 ]; then
    RATING="large (maxi)"
    COLOR="\033[1;31m" # Red
else
    RATING="huge (mega)"
    COLOR="\033[0;31m" # Dark Red
fi

echo ""
echo -e "  \033[1;36mstat\033[0m"
echo "  ----"
echo "  files: $FILE_COUNT"
echo "  lines: $LINE_COUNT"
echo ""
echo -e "  score: ${COLOR}${SCORE}\033[0m"
echo -e "  rating: ${COLOR}${RATING}\033[0m"
echo ""
