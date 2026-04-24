# Creating the needed conda enviornments

# SRA tools kits env, not really needed for pipeline only for test data

conda activate sra
# fastp enviornemnt
conda activate fastp
# Enviornemnt for Genome Assembler PVGA
conda create -n pvga python=3.10
conda install bioconda::blasr
# 
prefetch SRR38224410
fasterq-dump \
 SRR38224410 \
 --outdir ./raw_data \
 --split-files \
 --skip-technical

# Fastp cleaning time
mkdir cleaned_fasta
mkdir fastp_metrics
fastp -i ./raw_data/SRR38224410_1.fastq.gz -I ./raw_data/SRR38224410_2.fastq.gz -o ./cleaned_fasta/SRR38224410_cleaned_1.fastq.gz -O ./cleaned_fasta/SRR38224410_cleaned_2.fastq.gz --html ./fastp_metrics/SRR38224410.html --json ./fastp_metrics/SRR38224410.json -f 18 -F 18 -t 1 -T 

mkdir Assembled_Genomes

mkdir unmerged_reads

# PVGA only oworks with single-end reads so my paired-end reads need to be converted into a single-read format, this can be down with bbmerge
# creating a conda enviornment for bbmerge
zcat ./cleaned_fasta/SRR38224410_cleaned_1.fastq.gz ./cleaned_fasta/SRR38224410_cleaned_2.fastq.gz > ./cleaned_fasta/SRR38224410_merged.fastq
pigz -9 ./cleaned_fasta/SRR38224410_merged.fastq


# BBmerge is not working properly, atm the best best is to just concaentante the two files together
bbmerge.sh in1=./cleaned_fasta/SRR38224410_cleaned_1.fastq.gz in2=./cleaned_fasta/SRR38224410_cleaned_2.fastq.gz out=./cleaned_fasta/SRR38224410_merged.fastq outu1=./unmerged_reads/SRR38224410_unmerged_1.fastq outu2=./unmerged_reads/SRR38224410_unmerged_2.fastq
# Genome Assembly time with PVGA

pvga -r ./cleaned_fasta/SRR38224410_merged.fastq -b SarS_Cov2_ref.fasta -o ./Assembled_Genomes/
