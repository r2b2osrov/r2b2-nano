#!/bin/bash
#Title:         generate_stl.sh
#Description:   Script to generate stl files from to_stl folder .scad files
#Authors:       Pau Roura (@proura)
#Date:          20180610
#Version:       0.1
#Notes:         If no parameter have been given then all STL will be regenerated.
#  

DEST="./stl"
ORIG="./to_stl"

if [ -z "$1" ]; then
    rm ${DEST}/*.stl
    for file in ${ORIG}/*.scad; do
        filename=$(basename -- "$file")
        echo "Converting $(basename -- "$file") to ${filename%.*}.stl"
        openscad -o ${DEST}/${filename%.*}.stl $file
    done  
else 
    filename=$(basename -- "$1")
    rm ${DEST}/${filename%.*}.stl
    openscad -o ${DEST}/${filename%.*}.stl $1
fi

