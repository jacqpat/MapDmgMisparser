#!/bin/bash

check_what_file(){
    local result="false"
    filename=$(basename -- $1)
    if [ $filename == $2 ]
    then
        local result="true"
    fi
    echo "$result"
}

check_pathsfile(){
    is_pathfile=$(check_what_file $1 "MpDmg_paths.txt")
    if [ "$is_pathfile" = true ]
    then
        pathfile $1
    else
        echo "$1 is not the pathfile"
    fi
}

check_misfile(){
    is_misfile=$(check_what_file $1 "misincorporation.txt")
    if [ "$is_misfile" = true ]
    then
        echo "$1 is a misincorporation file"
    else
        echo "$1 is not a misincorporation file"
    fi
}

pathfile(){
    while IFS= read -r line
    do
        if [[ -d $line ]]
        then
            echo "$line is a directory"
        elif [[ -f $line]]
        then
            echo "$line is a file"
            check_pathsfile $line
            check_misfile $line
        else
            echo "$line is not a correct path"
        fi
    done < $1
}

# main
if [ $# -eq 0 ]
then
    echo "No arguments supplied";
    exit 1;
fi
for i in $@
do
    check_pathsfile $i
    #check_paths $i
done
