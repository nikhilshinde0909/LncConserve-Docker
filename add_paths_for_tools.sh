#!/bin/bash
# get paths
echo 'getting paths'
Activate_path=$(which activate 2>/dev/null)
bpipe_path=$(which bpipe 2>/dev/null)
hisat2_path=$(which hisat2 2>/dev/null)
stringtie_path=$(which stringtie 2>/dev/null)
gffread_path=$(which gffread 2>/dev/null)
gffcompare_path=$(which gffcompare 2>/dev/null)
samtools_path=$(which samtools 2>/dev/null)
bowtie2_path=$(which bowtie2 2>/dev/null)
bamToFastq_path=$(which bamToFastq 2>/dev/null)
fastp_path=$(which fastp 2>/dev/null)
seqtk_path=$(which seqtk 2>/dev/null)
python3_path=$(which python3 2>/dev/null)

# slncky
source $Activate_path slncky
python2_path=$(which python 2>/dev/null)
slncky_path=$(which slncky.v1.0 2>/dev/null)

# Add paths to tools.groovy
echo 'adding paths to tools.groovy'
echo "// Path to tools used by the pipeline"
echo "Activate=\"$Activate_path\"" 
echo "bpipe=\"$bpipe_path\"" 
echo "hisat2=\"$hisat2_path\"" 
echo "stringtie=\"$stringtie_path\"" 
echo "gffread=\"$gffread_path\"" 
echo "gffcompare=\"$gffcompare_path\"" 
echo "samtools=\"$samtools_path\"" 
echo "bowtie2=\"$bowtie2_path\"" 
echo "bamToFastq=\"$bamToFastq_path\"" 
echo "fastp=\"$fastp_path\"" 
echo "seqtk=\"$seqtk_path\"" 
echo "python3=\"$python3_path\"" 
echo "" 

echo "// Path to python 2.7 and slncky" 
echo "python2=\"$python2_path\"" 
echo "slncky=\"$slncky_path\"" 
