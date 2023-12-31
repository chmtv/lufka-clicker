#!/bin/sh
echo -ne '\033c\033]0;Topek\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/LufkaClicker.x86_64" "$@"
