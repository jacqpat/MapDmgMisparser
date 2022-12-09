#!/bin/bash

check_what_file(){
    # compare the given file
    # ($1) name to the given
    # string ($2)
    local result="false"
    filename=$(basename -- $1)
    if [ $filename == $2 ]
    then
        local result="true"
    fi
    echo "$result"
}

check_pathsfile(){
    # establish whether or not the
    # given text is our pathfile
    # "MpDmg_paths.txt".
    # And hence start the rest of
    # the procedure
    is_pathfile=$(check_what_file $1 "MpDmg_paths.txt")
    if [ "$is_pathfile" = true ]
    then
        pathfile $1
    else
        echo "$1 is not the pathfile"
    fi
}

mk_csv(){
    # in this version we consider that
    # misincorporation files have no reason
    # to be outside of a standard MapDamage
    # folder.
    if [[ -f $1 ]]
    then
        sample=$(basename $(dirname $1))
        foldname=$(basename $(dirname $(dirname $1)))
        ordername=$(echo $foldname | cut -d'.' -f2)
        speciesname=$(echo $foldname | cut -d'.' -f3 | cut -d '-' -f1)
        refname="${ordername}_${speciesname}"
        sed "/#/d" $1 | sed "s/ \+/;/g" > "dirsubs/${sample}_${refname}_misincorporation.csv"
        echo "dirsubs/${sample}_${refname}_misincorporation.csv"
    fi
}

check_misfile(){
    # like check_pathfile
    # but with a different string
    # to compare to.
    is_misfile=$(check_what_file $1 "misincorporation.txt")
    if [ "$is_misfile" = true ]
    then
        mk_csv $1
    else
        echo "$1 is not a misincorporation file"
    fi
}

check_4mpdmg(){
    # function for directories
    # assume that folder follows
    # MapDamage standard convention
    for mpdmg in $1/*mapDamage
    do
        path=$mpdmg/*/misincorporation.txt
        check_misfile $path
    done
}

pathfile(){
    # read the lines within
    # the path file and handle
    # them accordingly
    while IFS= read -r line
    do
        if [[ -d $line ]]
        then
            check_4mpdmg $line
        elif [[ -f $line ]]
        then
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
    echo "No argument supplied";
    exit 1;
fi
for i in $@
do
    check_pathsfile $i
done
