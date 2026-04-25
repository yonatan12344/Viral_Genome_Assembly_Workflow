nextflow.enable.dsl = 2

process fastp_cleaning {
    conda 'bioconda::fastp'
    publishDir 'fastp_cleaned', mode: 'copy'
    
input: 
    tuple val(sampleId), file(reads)
    

output:

    tuple val(sampleId), path("*cleaned_*.fastq.gz"), emit: reads
    path "*.json", emit: json
    path "*.html", emit: html

	
    script:
	def raw_sample_name = sampleId.split('_')[0]
    """
	fastp -i ${reads[0]} -I ${reads[1]} -o ${raw_sample_name}_cleaned_1.fastq.gz -O ${raw_sample_name}_cleaned_2.fastq.gz --html ${raw_sample_name}.html --json ${raw_sample_name}.json -f 18 -F 18 -t 2 -T 2
    """
    }

// pvga only accepts inputs that are single merged, ideally these need to be properly merged but for now, using zcat to merge them together is ok.



// when on linux change this gzcat to zcat, fun example of why docker would be usefull over conda (:
process merged_reads {
    publishDir 'remerged_assemblies', mode: 'copy'   
input: 
    tuple val(sampleId), file(reads)
output:
    path "*_merged.fastq", emit: merged_read
    script:
	def raw_sample_name = sampleId.split('_')[0]
    """
	zcat ${reads[0]} ${reads[1]} > ${raw_sample_name}_merged.fastq
    """
    }

// pvga time
process pvga_assembly {
    conda 'pvga bioconda::blasr'
    publishDir 'output_assembly', mode: 'copy'   
input: 
    path merged_assembly
    path ref_genome
output:
     path "Assembled_Genomes", emit: assembled
    script:
    """
    mkdir -p Assembled_Genomes
    pvga -r ${merged_assembly} -b ${ref_genome} -o ./Assembled_Genomes/
    """
    }

params.ref_seq = "SarS_Cov2_ref.fasta"
workflow {
input_ch = channel.fromPath(params.ref_seq)
raw_fasta = channel.fromFilePairs('./raw_data/*{1,2}.fastq.gz')
	fastp_cleaning(raw_fasta)
	merged_reads(fastp_cleaning.out.reads)
    pvga_assembly(merged_reads.out.merged_read, input_ch.first())
    }



