#!/bin/bash

source merqury-1.3

ref=${snakemake_input[0]}
meryl=${snakemake_input[1]}
prefix=${snakemake_params[0]}
out=${prefix}_merqury

cd Merqury

merqury.sh $meryl $ref $out > ${prefix}.log

