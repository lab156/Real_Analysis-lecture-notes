#!/bin/bash

#   Usage:
#     $ create_new_clase.sh [number of the class you want to create]
#   -h <dirname>
#   the flag -h nameofdir to create directory for homeworks
#   Example:
#   To create the file of class 4 quickly:
#    $ ./create_new_clase.sh 4
#   
# run with no arguments to create the next lecture file

#DEFAULT OPTIONS
FILESUFFIX=class
NAMEOFDIR=$1

while getopts h: opt; do
    case $opt in
        h)
            echo "Creating new hw dir: $OPTARG" >&2
            FILESUFFIX=paper
            NAMEOFDIR=$OPTARG
            ;;
        \?)
            echo "Invalid Option" >&2
            exit 2
            ;;
    esac
done


#RETURNS THE NAME OF THE FILE WITH THE LARGEST NUMERIC VALUE
function last_lecture {
regu="^[0-9]+$"
for fil in `ls`; do 
    if [[ $fil =~ $regu ]]; then 
        echo $fil;
    fi; 
done | sort -n | tail -1
}

#FUNCTION THAT CREATES A DIRECTORY AND ITS LINKS 
function new_dir {
    mkdir $1 &&\
        cp ./templates/this_$FILESUFFIX.tex $1 &&\
        touch $1/$FILESUFFIX.tex &&\
        #It appears that ln only works when they are created from 
        #the inside of the directory
        cd $1 &&\
        ln -s ../general.sty .
    }

        #add the line to the TEX file
function add_to_tex_file {
        TEX='../analysis_notes.tex'
        match='\\end{document}'
        insert='\\input{'$1'/'$FILESUFFIX'}'
        sed -i "s@$match@$insert\n$match@" $TEX
    }

if [ "$NAMEOFDIR" == "" ] ; then
    ll=`last_lecture`
    if [[ $ll == "" ]]; then
        #NO RESULTS; CREATE FIRST DIR
        new_name=1;
    else
        new_name=$(( 1 + $ll ));
    fi
    echo Creating new dir $new_name
   new_dir $new_name 
   add_to_tex_file $new_name
    exit 0
elif [ -a $NAMEOFDIR ] ; then
    echo "The file already exists!!!"
    exit 1
else
    new_dir $NAMEOFDIR
    exit 0
fi
