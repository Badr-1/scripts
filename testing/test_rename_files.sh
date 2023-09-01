#!/bin/bash

RED="\033[31m"
GREEN="\033[32m"
NORMAL="\033[0;39m"
bold=$(tput bold)
normal=$(tput sgr0)
script=$1
target=$2

touch {1..3}.bak
$script "bak" "backup"
for i in {1..3}; do
    if [[ ! -e backup$i.bak ]]; then
        echo "backup$i.bak does not exist"
        result="fail"
    else
        echo -e "${GREEN}${bold}backup$i.bak ✅ ${NORMAL}${normal}"
    fi
done
if [[ $result == "fail" ]]; then
    echo -e "${bold}$(basename $script) : ${RED}Test failed${NORMAL}${normal}"
    read -p "${bold}Enter manual result: ${normal}" manual_result
    echo -n "$(basename $script): $manual_result " >>$target
else
    echo -e "${bold}$(basename $script) : ${GREEN}Test passed${NORMAL}${normal}"
    echo -n "$(basename $script): pass " >>$target
fi
rm backup{1..3}.bak
