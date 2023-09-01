#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
NORMAL="\033[0;39m"
bold=$(tput bold)
normal=$(tput sgr0)
script=$1
target=$2
result=$($script)

username=$(echo $result | grep "$USER")
kernal_version=$(echo $result | grep "$(uname -r)")

if [[ -n $username && -n $kernal_version ]]; then
    echo -e "${bold}$(basename $script) : ${GREEN}Test passed${NORMAL}${normal}"
    echo -n "$(basename $script):pass " >>$target
else
    echo -e "${bold}$(basename $script) : ${RED}Test failed${NORMAL}${normal}"
    read -p "${bold}Enter manual result: ${normal}" manual_result
    echo "$(basename $script): $manual_result " >>$target
fi
