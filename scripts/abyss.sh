#!/bin/bash


source abyss-1.9.0


genome=${snakemake_input[0]}
out=${snakemake_output[0]}

mkdir Abyss

abyss-fac ${genome} > ${out}

