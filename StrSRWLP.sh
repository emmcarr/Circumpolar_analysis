#!/bin/bash 
#$ -cwd 
#$ -j y
#$ -S /bin/bash 
#$ -V
#$ -N STR_SRW ## job name
#$ -t 1-5 # this will launch two parallel instances of this script. In ne the variable $SGE_TASK_ID=1, in the other $SGE_TASK_ID will be 2
#$ -o ./STRUCTURE/Results

#$ -q all.q
#$ -pe multi 3 # the script itself will command 3 processors in parallel, this can be referred to as NSLOTS in the commandline invocation

# Get the latest version of structure, first make sure the old one is unloaded.
# module unload structure
 module load structure/2.3.4b

# make sure the following is only done once, in the case of $SGE_TASK_ID=1
if [ $SGE_TASK_ID -eq 1 ]; then
    structure -m mainparams.LocPrior.k1 -e extraparams
fi

parallel -P $NSLOTS --no-notice "structure -m ./STRUCTURE/mainparams.LocPrior.k1 -e ./STRUCTURE/extraparams -K $SGE_TASK_ID -i ./STRUCTURE/SRW_StrInp_Dec16.gdv -o outfile_k${SGE_TASK_ID}_rep{}" ::: {1..2}
