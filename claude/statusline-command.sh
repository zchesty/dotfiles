#!/bin/sh
# Lean Claude Code statusline: model effort · ±changes · branch · ctx%
# Pure sh + git; no jq. Reads the session JSON on stdin.
input=$(cat)

# First string value for "key": "value" (works on compact or pretty JSON).
str() {
  printf '%s' "$input" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" | head -n1 |
    sed 's/.*:[[:space:]]*"//; s/"$//'
}
# First numeric value for "key": 123(.45).
num() {
  printf '%s' "$input" | grep -o "\"$1\"[[:space:]]*:[[:space:]]*[0-9][0-9.]*" | head -n1 |
    sed 's/.*:[[:space:]]*//'
}

model=$(str id)
effort=$(str level)
cwd=$(str current_dir)
[ -z "$cwd" ] && cwd=$(pwd)
ctx=$(num remaining_percentage)

branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
changes=$(git -C "$cwd" status --short 2>/dev/null | grep -c .)

green=$(printf '\033[32m'); blue=$(printf '\033[34m'); yellow=$(printf '\033[33m'); reset=$(printf '\033[0m')

parts=""
add() { [ -n "$parts" ] && parts="$parts · $1" || parts="$1"; }

if [ -n "$model" ]; then
  [ -n "$effort" ] && add "${yellow}${model} ${effort}${reset}" || add "${yellow}${model}${reset}"
fi
[ "${changes:-0}" -gt 0 ] 2>/dev/null && add "${blue}±${changes}${reset}"
[ -n "$branch" ] && add "${green}${branch}${reset}"
[ -n "$ctx" ] && add "${yellow}${ctx%.*}% ctx${reset}"

printf '%s\n' "$parts"
