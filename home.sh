#!/bin/bash

get_misalignment(dir){

}

find_mapDamage(dir){

}

check_dirname(dir){
    dirname="$(basename -- $dir)"
    if [ "$dirname" == *mapDamage ]
    then
        get_misincorporations($dir);
    else
        find_mapDamage($dir);
    fi
}

check_filename(fil){
    filname="$(basename -- $fil)"
    if [ "$filname" == "misincorporation.txt" ]
    then
        txt2csv($fil);
    else
        echo "$arg is not a misincorporation file"
    fi

}

check_paths(arglist){
    for arg in $arglist
    do
        if [[ -d $arg ]]
        then
            echo "$arg is a directory";
            check_dirname;
        elif [[ -f $arg ]]
        then
            echo "$arg is a file";
        else
            echo "$arg is not valid";
            exit 1;
        fi
    done
}

if [ $# -eq 0 ]
then
    echo "No arguments supplied";
    exit 1;
fi
arglist=( "$@" )
check_paths($arglist)