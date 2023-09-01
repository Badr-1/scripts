#!/bin/bash

dispaly_script() {
    echo -e "${bold}${YELLOW}Script Content:${NORMAL}${normal}"
    batcat -Pp $script
}

run_test() {
    if [[ -n $test ]]; then
        $test "./$script" $root/.output.csv
    fi
}

next_script() {
    read -p "${bold}Press Enter to move to next script ${normal}"
    clear
}

next_repo() {
    cd $root
    rm -rf $reponame
    read -p "${bold}Press Enter to move to the next repo ${normal}"
    clear
}

test_repo() {
    name=$(echo "$entry" | cut -f1)
    email=$(echo "$entry" | cut -f2)
    id=$(echo "$entry" | cut -f3)
    github_link=$(echo "$entry" | cut -f4)
    reponame="$(echo $github_link | sed 's/\.git$//' | awk -F '/' '{print $NF}')"
    echo "${bold}Name:${normal} $name"
    echo "${bold}Email:${normal} $email"
    echo "${bold}ID:${normal} $id"
    echo "${bold}GitHub Link:${normal} $github_link"
    echo "${bold}Repo Name:${normal} $reponame"

    if [[ -e $reponame ]]; then
        echo "${bold}Repo $reponame already exists${normal}"
    else
        git clone $github_link
    fi
    scripts=("system_info.sh" "file_check.sh" "rename_files.sh" "calculator.sh")
    lsd $reponame
    read -p "${bold}Pause to fix the repo if needed. Press Enter to continue${normal}"

    # check if session 4 is in the repo
    if [[ ! $(find $reponame -maxdepth 1 -type d | grep '4') ]]; then
        echo -e "${bold}${RED}Session 4 folder not found${NORMAL}${normal}"
        rm -rf $reponame
        echo -en "$name,$email,$id,$github_link," >$root/.output.csv
        for script in ${scripts[@]}; do
            echo -n "$(basename $script): Not found " >>$root/.output.csv
        done
        next_repo
        continue
    else
        echo -en "$name,$email,$id,$github_link," >$root/.output.csv
        path="$(find $reponame -maxdepth 1 -type d | grep '4')"
        cd "$path"
    fi

    clear
    for script in ${scripts[@]}; do
        # check if found
        if [[ ! -e $script ]]; then
            lsd
            echo "$script Not found"
            read -p "${bold}Does the script exist? (y/n): ${normal}" answer
            if [[ $answer == 'y' ]]; then
                wrong_name=$(find . -type f | fzf)
                mv $wrong_name $script
            elif [[ $(ls | grep -iE "\.(png|jpg|jpeg|md|txt)") ]]; then
                echo -n "$(basename $script): other " >>$root/.output.csv
                read -p "${bold}Press Enter to move to next script ${normal}"
                clear
                continue
            else
                echo -n "$(basename $script): Not found " >>$root/.output.csv
                read -p "${bold}Press Enter to move to next script ${normal}"
                clear
                continue
            fi
        fi
        chmod +x $script
        case $script in
        system_info.sh)
            args=""
            test="$root/test_system_info.sh"
            dispaly_script
            $root/test_syntax.sh "./$script" "$args" true
            run_test
            next_script
            ;;
        file_check.sh)
            args="file_check_test.txt $root"
            test="$root/test_file_check.sh"
            dispaly_script
            $root/test_syntax.sh "./$script" "$args" true
            run_test
            next_script
            ;;
        rename_files.sh)
            touch file.tmp
            args="tmp temp"
            test="$root/test_rename_files.sh"
            dispaly_script
            $root/test_syntax.sh "./$script" "$args" true
            run_test
            next_script
            rm *.tmp
            ;;
        calculator.sh)
            args=""
            test=""
            dispaly_script $script
            echo -e "${bold}$script ${YELLOW}Manual Testing Started${NORMAL}${normal}"
            $root/test_syntax.sh "./$script" "$args" false
            echo -e "${bold}$script ${YELLOW}Manual Testing Finished${NORMAL}${normal}"
            read -p "${bold}Enter manual result: ${normal}" manual_result
            echo -n "$(basename $script): $manual_result " >>$root/.output.csv
            ;;
        esac
    done
}

save_result() {
    output=$(cat $root/.output.csv)
    gid=$(cut -d',' -f4 $root/.output.csv)
    oldline=$(grep -n $gid $root/$target | cut -d':' -f1)
    if [[ -n $oldline ]]; then
        sed -n "${oldline}"p $root/$target >$root/.old.csv
        git diff --no-index --word-diff=color $root/.old.csv $root/.output.csv
        read -p "Do you want to replace the old result? (y/n): " answer

        if [[ $answer == 'y' ]]; then
            old=$(sed -n "${oldline}"p $root/$target)
            new=$output
            sed -i "s|$old|$new|" $root/$target
            rm $root/.old.csv -rf
        fi
    else
        echo -e "\\n$output" >>$root/$target
    fi
    echo -e "${bold}${GREEN}Testing Finished${NORMAL}${normal}"
    echo $(head -n1 $root/$target) >.tmp.csv
    if [[ -n $oldline ]]; then
        sed -n "${oldline}"p $root/$target >>.tmp.csv
    else
        echo $(tail -n1 $root/$target) >>.tmp.csv
    fi
    batcat -Pp .tmp.csv
    rm .tmp.csv
}

YELLOW="\033[33m"
NORMAL="\033[0;39m"
RED="\033[31m"
GREEN="\033[32m"
bold=$(tput bold)
normal=$(tput sgr0)

root=$(pwd)
source="demo.tsv"
target="demo.csv"
repos_number=$(wc -l <"$source")
echo "${bold}Number of repos: $repos_number${normal}"

for student in $(seq 1 $repos_number); do
    entry=$(sed -n "$student"p $source)
    test_repo
    save_result
    next_repo
done
