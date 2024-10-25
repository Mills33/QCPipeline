#!/bin/bash

genome=${snakemake_input[0]}
min=${snakemake_params[0]}
max=${snakemake_params[1]}
min_out=LengthStats/${min}_lengths.txt
max_out=LengthStats/${max}_lengths.txt
table_out=LengthStats/length_stats.tsv

source package 638df626-d658-40aa-80e5-14a275b7464b # samtools 1.15.1

samtools faidx $genome

cut -f 1,2 ${genome}.fai | awk -v min=$min '{if($2 >= min){print $0}}' > $min_out
cut -f 1,2 ${genome}.fai | awk -v max=$max '{if($2 >= max){print $0}}' > $max_out

wc -l *txt > $table_out

touch LengthStats/length_stats.done
