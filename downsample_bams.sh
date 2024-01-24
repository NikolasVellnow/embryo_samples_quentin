#!/bin/bash

# type in path to text file with list of bam files
FILE=$1

DOWNSAMPLED_FILES=$2

MERGED_FILE=$3

#conda activate samtools

# create new file to store the names of the downsampled files
> $DOWNSAMPLED_FILES

while read line
do
    echo "$line"
    FILENAME=${line%.bam*}
    echo $FILENAME
    # create random subset with size of 1/16 of original read(-pairs)
    samtools view -bo "$FILENAME"_downsampled.bam -@ 8 -s 777.0625 "$line"
    # write the names of the downsampled files to text file
    DOWN_FILENAME=${FILENAME}_downsampled.bam
    echo $DOWN_FILENAME >> $DOWNSAMPLED_FILES
done <$FILE


samtools merge -b $DOWNSAMPLED_FILES -@ 8 -o $MERGED_FILE

