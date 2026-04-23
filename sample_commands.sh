# Creating the needed conda enviornments

# SRA tools kits env, not really needed for pipeline only for test data

conda activate sra
# fastp enviornemnt
conda activate fastp
# Enviornemnt for Genome Assembler PVGA
conda create -n pvga python=3.10
conda install bioconda::blasr

prefetch SRR38224410

