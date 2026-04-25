# Viral Genome Assembly Pipeline
The goal of this project is to build a simple nextflow pipeline, for reference based viral genome assembly
from illumina short read sequencing data. A test dataset to showcase the process has been included.

# QuickStart
Have your paired .fastq.gz NGS data in a cwd in a folder called raw_data, alongside the nextflow script.
Make sure it follows this type of naming convention "./raw_data/*{1,2}.fastq.gz".
You can run the script like so,

nextflow run genome_assembly.nf   --process.cpus 6   --process.memory 16GB
* By default genome assembly uses SarS_Cov2_ref.fasta as the reference sequence for assembly, this
can be changed by using the --ref_seq <genome_sequence.fasta> as a parameter when running the nextflow pipeline

# Requirments
* Conda
* x86 Linux
* Nextflow
* Intial reads needs to be .fastq.gz
* paired end NGS data in the CWD of the pipleine, in a folder called raw_data. Ma
# Steps of pipeline
1. fastp trims the first 18 bp and last 2 bp of the reads
2. Cleaned Reads are then concatened into one read file with zcat, since pvga only works with single end data
3. Viral Genome Assembly with pvga

# Future Improvments
1. This code does not work on MAC atm, due to issues with zcat, and getting the conda enviornment for pvga.
to aid in reproducibilty I plan to modify the pipeline to use docker instead of conda.
2. pvga might be a suboptimal reference based assembler for viral genomes. I might switch this assembler for something
else in the future
   
