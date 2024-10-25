configfile: 'config.yaml'
localrules: QC_pipeline,busco_plot

prefix = config['Name']


rule QC_pipeline:
    input:
        "Abyss/abyss_results.txt",
        "Busco/busco_results.tsv",
        "Busco/{prefix}_busco.png",
        "Busco/{prefix}_busco.csv",
        "Quast/report.html",
        "Quast/report.pdf",
        "Quast/transposed_report.tsv",
        "LengthStats/length_stats.txt"
    params:
        wd = config['WD'],
        pr = config['Name']
    output:
        "Final_summary/{prefix}_abyss_results.txt",
        "Final_summary/{prefix}_busco_results.tsv",
        "Final_summary/{prefix}_busco.png",
        "Final_summary/{prefix}_busco.csv",
        "Final_summary/{prefix}_quast.html",
        "Final_summary/{prefix}_quast_report.pdf",
        "Final_summary/{prefix}_quast_stats.tsv",
        "Final_summary/{prefix}_QC_pipeline.complete",
        "Final_summary/{prefix}_length_stats.txt"
    script:
        "scripts/qc_summary.sh"

rule busco:
    input:
        fa = config['Assembly'],
        db = config['Database']
    params:
        pr = config['Name']
    output:
        "Busco/busco_results.tsv",
        "Busco/full_table.tsv"
    script:
        "scripts/busco.sh"
rule busco_plot:
    input:
        tab = "Busco/full_table.tsv"
    params:
        pr = config['Name'],
    output:
        "Busco/{prefix}_busco.png",
        "Busco/{prefix}_busco.csv"
    script:
        "scripts/busco_plot.sh"
rule quast:
    input:
        fa = config['Assembly']
    output:
        "Quast/report.html",
        "Quast/report.pdf",
        "Quast/transposed_report.tsv"
    script:
        "scripts/quast.sh"
rule abyss:
    input:
        fa = config['Assembly']
    params:
        pr = config['Name']
    output:
        "Abyss/abyss_results.txt"
    script:
        "scripts/abyss.sh"

rule length_calculations:
     input:
        fa = config['Assembly']
     params:
        min = config['Min_length'],
        max = config['Max_length']
     output:
        "LengthStats/length_stats.done"
     script:
         "scripts/length_stats.sh"
"""
rule meryl_db:
    input:
        reads = config['Reads']
    output:
        directory("Merqury/db.meryl")
    script:
        "scripts/meryl.sh"
rule merqury:
    input:
        fa = config['Assembly'],
        meryl = "Merqury/db.meryl"
    output:
        directory("Merqury/logs")
    params:
        pr = config['Name']
    script:
        "scripts/merqury.sh"
"""
