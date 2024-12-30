/***********************************************************
 ** Author: Nikhil Shinde <sd1172@srmist.edu.in>
 ** Last Update: 29/05/2023
 *********************************************************/

VERSION="1.00"

//option strings to pass to tools
hisat2_options="--mp 2"
stringtie_options="-m 200 -a 10 --conservative -g 50 -u -c 3"
stringtie_merge_options="-m 200 -c 3 -T 1"
gffread_options="-l 200 -U -T"
unmapped_bam_options="-f 4"
unmapped_bam_paired_options="-f 12"
CPAT_options=""
slncky_options=""
slncky_ortho_options="--no_filter --minMatch=0.01 --no_orf --pad=100000"

// Input options
fastqFormatPaired="%_*.fastq.gz"
fastqFormatSingle="%.fastq.gz"

load args[0]

fastqInputFormat=fastqFormatPaired
if(reads_R2=="") fastqInputFormat=fastqFormatSingle

codeBase = file(bpipe.Config.config.script).parentFile.absolutePath
Liftover = codeBase + "/scripts/Liftover.py"
ensembl_gtf2bed = codeBase + "/scripts/ensembl_gtf2bed.py"

load codeBase+"/tools.groovy"
load codeBase+"/stages/fastp.groovy"
load codeBase+"/stages/rRNA_unmapped.groovy"
load codeBase+"/stages/align_assembly.groovy"
load codeBase+"/stages/merge_and_compare_annotations.groovy"
load codeBase+"/stages/lnc_npc_transcript_filter.groovy"
load codeBase+"/stages/slncky.groovy"

/******************* Here are the pipeline stages **********************/

set_input = {
   def files=reads_R1.split(",")
   if(reads_R2!="") files+=reads_R2.split(",")
   forward files
}

run_check = {
    doc "check that the data files exist"
    produce("checks_passed") {
        exec """
            echo "Running lnc RNA analysis pipeline version $VERSION" ;
	    echo "Using ${bpipe.Config.config.maxThreads} threads" ;
            echo "Checking for the data files..." ;
	    for i in $rRNAs $genome $annotation $inputs.fastq.gz ; 
                 do ls $i 2>/dev/null || { echo "CAN'T FIND ${i}..." ;
		 echo "PLEASE FIX PATH... STOPPING NOW" ; exit 1  ; } ; 
	    done ;
            echo "All looking good" ;
            echo "Running lnc RNA analysis pipeline version $VERSION.. checks passed" > $output
        ""","checks"
    }
}

nthreads=bpipe.Config.config.maxThreads

run { set_input + run_check + 
	quality_trimming.using(threads: nthreads) +
	unmapped_reads_to_rRNAs.using(threads: nthreads) +
	genome_guided_assembly +
	annotation_compare.using(threads: nthreads) +
	lnc_npc_transcript_selection.using(threads: nthreads) +
	slncky_run.using(threads: nthreads) 
}
