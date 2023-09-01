#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
NORMAL="\033[0;39m"
bold=$(tput bold)
normal=$(tput sgr0)
script=$1
target=$2
root=$(dirname $2)
# testing for file found
result=$($script file_check_test.txt $root)
if [[ $(echo $result | grep "found me") ]]; then
    echo -e "${bold}$(basename $script) : ${GREEN}Test 1 passed${NORMAL}${normal}"
    # testing for file not fount
    result=$($script not_found.txt $root)
    if [[ $(echo $result | grep -Ei "File does not exist") ]]; then
        echo -e "${bold}$(basename $script) : ${GREEN}Test 2 passed${NORMAL}${normal}"
        echo -n "$(basename $script): pass " >>$target
    else
        read -p "${bold}Enter manual result: ${normal}" manual_result
        echo -n "$(basename $script): $manual_result " >>$target
    fi
else
    echo -e "${bold}$(basename $script) : ${RED}Test failed${NORMAL}${normal}"
    read -p "${bold}Enter manual result: ${normal}" manual_result
    echo -n "$(basename $script): $manual_result " >>$target
fi
