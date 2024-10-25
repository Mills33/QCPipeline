#!/bin/bash
#SBATCH -p ei-medium# partition (queue)
#SBATCH -c 1
#SBATCH --mem 4G # memory pool for all cores
#SBATCH -t 4-10:00 # time (D-HH:MM)
#SBATCH -o slurm.%N.%j.out # STDOUT
#SBATCH -e slurm.%N.%j.err # STDERR
#SBATCH --mail-type=END,FAIL # notifications for job done & fail
#SBATCH --mail-user=camilla.ryan@earlham.ac.uk # send-to add

source activate snakemake

snakemake --workflow-profile sm_profile Final_summary/{NAME}_QC_pipeline.complete


source deactivate
