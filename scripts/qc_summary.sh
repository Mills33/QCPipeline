#!/bin/bash


abyss=${snakemake_input[0]}
busco=${snakemake_input[1]}
busco_plot=${snakemake_input[2]}
busco_csv=${snakemake_input[3]}
quast_html=${snakemake_input[4]}
quast_report=${snakemake_input[5]}
quast_tsv=${snakemake_input[6]}
length_stats=${snakemake_input[7]}

wd=${snakemake_params[0]}
prefix=${snakemake_params[1]}

abyss_out=${snakemake_output[0]}
busco_out=${snakemake_output[1]}
busco_plot_out=${snakemake_output[2]}
busco_csv_out=${snakemake_output[3]}
quast_html_out=${snakemake_output[4]}
quast_report_out=${snakemake_output[5]}
quast_tsv_out=${snakemake_output[6]}
qc_summary=${snakemake_output[7]}
length_out=${snakemake_output[8]}

cd ${wd}

cp ${abyss} ${abyss_out}
cp ${busco} ${busco_out}
cp ${busco_plot} ${busco_plot_out}
cp ${busco_csv} ${busco_csv_out}
cp ${quast_html} ${quast_html_out}
cp ${quast_report} ${quast_report_out}
cp ${quast_tsv} ${quast_tsv_out}
cp ${length_stats} ${length_out}



touch ${qc_summary}
echo $wd > ${qc_summary}
