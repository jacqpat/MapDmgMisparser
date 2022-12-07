#!/bin/bash

get_misincorporations(dir){
    # note: do NOT use path to the sub-folder
    # within mapDamage folders. Otherwise this
    # whole thing won't work
    for mis in $dir/*/misincorporation.txt
    do
        echo "$mis";
    done
}

check_dirname(dir){
    # check if directory is a mapDamage directory
    # TO DO: test if the recursivity work
    dirname="$(basename -- $dir)"
    if [ "$dirname" == *mapDamage ]
    then
        get_misincorporations($dir);
    else
        for d in $dir*/
        do
            check_dirname($d);
        done
    fi
}

check_filename(fil){
    # check if file is a misincorporation file
    filname="$(basename -- $fil)"
    if [ "$filname" == "misincorporation.txt" ]
    then
        txt2csv($fil);
    else
        echo "$arg is not a misincorporation file"
    fi

}

check_paths(arglist){
    # check if args in list are directory
    # or files and launch the appropriate
    # fonctions.
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
# main
if [ $# -eq 0 ]
then
    echo "No arguments supplied";
    exit 1;
fi
arglist=( "$@" )
check_paths($arglist)