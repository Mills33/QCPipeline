#!/bin/bash
###
# Takes the full_table.csv producedd by busco and counts the number of times each Busco
# gene appears. Then submits the Rscript that plots this information
#

source merqury-1.3

table=${snakemake_input[0]}
prefix=${snakemake_params[0]}
out=${snakemake_output[0]}


cat ${table}  | cut -f 1 | sort | uniq -c | sort -nr | grep -v '#' > Busco/${prefix}_busco_plot.tsv

Rscript scripts/busco_plot.R ${prefix} 
