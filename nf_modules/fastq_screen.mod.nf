#!/usr/bin/env nextflow
nextflow.enable.dsl=2


/* ========================================================================================
    DEFAULT PARAMETERS
======================================================================================== */
params.bisulfite  = ''
params.single_end = false


/* ========================================================================================
    PROCESSES
======================================================================================== */
process FASTQ_SCREEN {

	label 'fastqScreen'
	tag "$name" // Adds name to job submission instead of (1), (2) etc.
	
	input:
		tuple val(name), path(reads)
		val(outputdir)
		val(fastq_screen_args)
		val(verbose)

	output:
	  	//path "*png",  emit: png
	  	path "*html", emit: html
	  	path "*txt",  emit: report
		  
		publishDir "$outputdir/qc/fastq_screen", mode: "link", overwrite: true

	script:
		// Verbose
		if (verbose){
			println ("[MODULE] FASTQ SCREEN ARGS: " + fastq_screen_args)
		}

		// Single-end
		if (params.single_end){
			// TODO: Add single-end parameter
		}
		else {
			// for paired-end files we only use Read 1 (as Read 2 tends to show the exact same thing)
			if (reads instanceof List) {
				reads = reads[0]
			}
		}

		"""
		module load fastq_screen

		fastq_screen --conf /cluster/work/nme/software/config/fastq_screen.conf --aligner 'bowtie2' $params.bisulfite $fastq_screen_args $reads
		"""
}
