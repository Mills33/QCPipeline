#!/bin/bash

source package quast-5.0.2 

genome=${snakemake_input[0]}

quast.py -o Quast ${genome}
