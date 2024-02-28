/*
 * Filter the raw VCF files using GATK VariantFiltration
 */
process filterVCF {

    label 'process_medium'
    //container 'variantvalidator/gatk4:4.3.0.0'
    
    tag "$vcfFile"

    // Publish VCF files to the specified directory
    publishDir("$params.outdir/VCF", mode: "copy")

    input:
    tuple val(sample_id), file(vcfFile)
    path indexFiles

    // Output channel for sample_id and filtered VCF files
    output:
    tuple val(sample_id), file("*.vcf")

    // Script section to run the process
    script:
    """
    # Print a message indicating the start of the process for the current sample
    echo "Running Variant Filtration for Sample: ${vcfFile}"

    genomeFasta="\$(find -L . -name '*.fasta')"

    # Rename the dictionary file to the expected name
    mv "\${genomeFasta}.dict" "\${genomeFasta%.*}.dict"

    outputVcf="\$(basename ${vcfFile} .vcf).filtered.vcf"

    # Use GATK VariantFiltration to filter the input VCF file
    gatk VariantFiltration -R "\${genomeFasta}" -V "${vcfFile}" -O "\${outputVcf}"

    # Print a message indicating the completion of variant filtration for the current sample
    echo "Variant Filtering for Sample: ${vcfFile} Complete"
    """
}
