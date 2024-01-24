#!/bin/bash -l
#SBATCH --partition=med
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=07:00:00
#SBATCH --cpus-per-task=20
#SBATCH --mem-per-cpu=3G
#SBATCH --job-name=downsample_bams_job
#SBATCH --mail-user=nikolas.vellnow@tu-dortmund.de
#SBATCH --mail-type=All

# type in path to text file with list of bam files
FILE=$1

# name for file to be created that contains names of all downsampled bams
DOWNSAMPLED_FILES=$2

# name for the resulting merged output bam file
MERGED_FILE=$3

NUM_THREADS=$4


T0=$(date +%T)
echo "Start data processing:"
echo $T0
conda activate samtools

# create new file to store the names of the downsampled files
> $DOWNSAMPLED_FILES

while read line
do
    echo "$line"
    FILENAME=${line%.bam*}
    echo $FILENAME
    # create random subset with size of 1/16 of original read(-pairs)
    samtools view -bo "$FILENAME"_downsampled.bam -@ $NUM_THREADS -s 777.0625 "$line"
    # write the names of the downsampled files to text file
    DOWN_FILENAME=${FILENAME}_downsampled.bam
    echo $DOWN_FILENAME >> $DOWNSAMPLED_FILES
done <$FILE


samtools merge -b $DOWNSAMPLED_FILES -@ $NUM_THREADS -o $MERGED_FILE

conda deactivate

T1=$(date +%T)
echo "Finished data processing:"
echo $T1

echo "done"

