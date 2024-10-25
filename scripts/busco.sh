#!/bin/bash
###
# Runs busco and takes the short_summary.txt to create a more workable table that can be used downstream
#
#

source busco-5.3.2


genome=${snakemake_input[0]}
db=${snakemake_input[1]}
prefix=${snakemake_params[0]}
out=$(echo "${snakemake_output[0]}" | cut -d '/' -f 2)

mkdir Busco
cd Busco

busco -i ${genome} -o ${prefix} -l ${db} -f --offline -c 4 --mode genome

cd ${prefix}

grep -A 6 'C:' short*.txt | tail -n 6 | awk -F '\t' 'BEGIN {OFS = FS}{print $3, $2}' > ${out}.tmp


Total=$( awk -F '\t' 'NR == 6 {print $2}' ${out}.tmp) ; awk -F '\t' -v total="$Total" 'BEGIN {OFS = "\t"}{$3 =  ($2/total)*100}{print $1,$2,$3, total}' ${out}.tmp > ${out}

rm ${out}.tmp

mv ${out} ../
mv run*/full_table.tsv ../
