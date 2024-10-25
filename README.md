The following snakefile controls a QC workflow designed to assess genome asssemblies.
It requires the assembly, reads, a sample name, min and max fragment length values (explained below), directory to Busco DB that you want to use. Parameters are entered into a confif file
called config.yaml.

Currently it expects the following structure and runs jobs automatically on the cluster:

In your wd: the directory of scripts and sm_profile - which is the information needed for the cluster. Then the snakefile, config.yaml file and qc_pipeline.sh.

The pipeline is run by :

1. Entering information into the config file:

WD: # path to your working directory
Assembly: # Path to the genome assembly
Name: # Whatever you want to call your experiment - this will be used as a prefix for output
Database: #Path to the Busco database you have chosen
Min_length*: # EXAMPLE 10000000
Max_length*: #EXAMPLE 30000000
Reads: #Path to reads

*Min and max length are used to calculate how many contigs/unitigs in your assembly are above the minimum and maximum length. These are arbitrary and at the users discretion however it can be used to get an idea of how many chromosome length fragments there are.
For example banana chromosomes tend to be between 20 - 40mbp above 10 -30mbp was used because I deemed that good enough overall if we had fragments of that size. It is important to remember that assemblers can have a hard time around centromeres therefore a value around half of a chromosome length (10mbp here) is useful as well.

2. Edit qc_pipeling by replacing {NAME} with whatever NAME is in the config file.

3. Sbatch qc_pipeline.sh


SNAKEFILE

A copy of the snakefile has been commented to better understand what is happening.

configfile: 'config.yaml'
localrules: QC_summary, busco_plot ## These are the rules which do not need to run on the cluster so do not have a profile for the cluster.


###This rule collates the most relevant outputs, renames them and puts them in Final_summary directory
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

###Runs busco and also creates a more workable output table
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

###Produces plot that says how many times each busco gene found in assembly gives an idea of haplotype. Also produces table.
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

###Quast
rule quast:
    input:
        fa = config['Assembly']
    output:
        "Quast/report.html",
        "Quast/report.pdf",
        "Quast/transposed_report.tsv"
    script:
        "scripts/quast.sh"

###Abyss-fc contiguity and assembly stats - this may be redundant with quast
rule abyss:
    input:
        fa = config['Assembly']
    params:
        pr = config['Name']
    output:
        "Abyss/abyss_results.txt"
    script:
        "scripts/abyss.sh"

###Generates 2 column files with all contigs/unitigs you have over both the minimum and maximum user defined size, also how many contigs/unitigs at each size threshold.
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

""""
###Creates meryl db of kmer counts - currently this is not working
rule meryl_db:
    input:
        reads = config['Reads']
    output:
        directory("Merqury/db.meryl")
    script:
        "scripts/meryl.sh"

###generates plots, qv and completeness from kmer comparison between assembly and reads
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
