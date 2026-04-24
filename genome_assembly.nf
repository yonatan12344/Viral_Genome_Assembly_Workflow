nextflow.enable.dsl = 2

process fastp_cleaning {
    conda 'bioconda::fastp'
    publishDir
    input:
    output:
    script:
    """
    """
    }





process paired_to_single {
    conda ''
    publishDir
    input:
    output:
    script:
    """
    """}




process viral_assembly {publishDir
    input:
    output:
    script:
    """
    """}




workflow {}
