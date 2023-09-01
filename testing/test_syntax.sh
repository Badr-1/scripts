#!/bin/bash

RED="\033[31m"
NORMAL="\033[0;39m"
bold=$(tput bold)
normal=$(tput sgr0)
script=$1
args=$2
redirect=$3
echo syntax check for: $script $args

if [[ $redirect == true ]]; then
    $script $args >/dev/null
else
    $script $args
fi

while [[ $? -ne 0 ]]; do
    echo -e "${bold}${RED}Failed To Run $(basename $script)$NORMAL${normal}"
    read -p "Press Enter to edit $script: " answer
    vim $script
    $script $args
done
