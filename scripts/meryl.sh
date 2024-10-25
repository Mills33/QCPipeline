#!/bin/bash

source merqury-1.3


reads=${snakemake_input[1]}
out=${snakemake_output[0]}


mkdir Merqury

meryl k=21 threads=8 memory=600g count ${reads} output ${out}


