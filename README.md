# LncConserve-Docker
A pipeline for lncRNA identification and inter-species lncRNA conservation analysis

# Introduction
Long non-coding RNA is the major class of non-coding RNA with lower expression than mRNAs, complex expression patterns, and low conservation. The present investigation aimed to develop an automated pipeline for lncRNA identification using RNA-seq and inter-species conservation analysis. The pipeline takes raw \*.fastq.gz, rRNA sequences (\*.fa) reference genome (\*.fa), and annotations (\*.gtf) for the species and related species. Also, we have provided additional scripts to download rRNA sequences, reference genomes, and annotations from Ensembl plants.

<p align="center">
  <img src="https://github.com/nikhilshinde0909/LncConserve-Docker/blob/main/LncConserve.png" width=50% height=25%>
</p>

# Implementation
1. To execute the steps in the pipeline, download the latest release of LncConserve to your local system with the following command 
```
git clone https://github.com/nikhilshinde0909/LncConserve-Docker.git
```

2. Rename and change directory.
```
mv LncConserve-Docker LncConserve && cd LncConserve
````

3. Build a docker image from the docker file
```
docker build -t nikhilshinde0909/lncconserve .
```

4. Run the following commands and check LncConserve and tool.groovy has been created and configured with the proper paths
```
docker run --rm -it nikhilshinde0909/lncconserve bash
cd LncConserve/
cat tools.groovy
exit
```

5. Prepare your inputs and data.txt in the working directory
```
mkdir data
Working directory
├── data
│   ├── SRR975551_1.fastq.gz
│   ├── SRR975552_1.fastq.gz
│   └── (and other fastq.gz files)
│   ├── SRR975551_2.fastq.gz
│   ├── SRR975552_2.fastq.gz
│   └── (and other fastq.gz files)
│   └── hg38.rRNA.fasta
|   └── hg38.genome.fasta
|   └── hg38.annotation.gtf
|   └── (and other files)
└── data.txt 
```  
Copy your RNA-seq reads (\*.fastq.gz), rRNA sequences (\*.fa), reference genomes (\*.fa), related sp. reference genome (\*.fa), annotations (\*.gtf) and liftover files in data directory; create file data.txt in the same by using data_template.txt and add paths for raw fastq.gz, rRNA sequences, reference genome, rel sp. reference genome, annotations and liftover files in the same \
6. If you don't have reference genome, annotations, and rRNA sequence information; you can download the same with the script provided with the pipeline as follows
```
python check_ensembl.py org_name
eg. python find_species_in_ensembl.py Sorghum
> sbicolor
python ensembl.py org_name_in_ensembl
eg. python download_datasets_ensembl.py sbicolor
> Ensembl version 56 <- download the datasets
```
Similarly, if you don't have liftover files for conservation analysis then you can keep it blank as such or generate it through genome alignments of reference and query species genomes as follows
```
python Liftover.py <threads> <genome> <org_name> <genome_related_species> <rel_sp_name> <params_distance>
eg.
python Liftover.py 16 Sorghum_bicolor.dna.toplevel.fa Sbicolor Zea_mays.dna.toplevel.fa Zmays near
```

This will produce protein-coding, non-coding, mirRNA, and snoRNA bed files for slncky.

7. Pipeline is ready for execution, run the LncConserve using docker in your working directory as follows
```
docker run \
    -v $(pwd)/data:/pipeline/data \
    -v $(pwd)/data.txt:/pipeline/data.txt \
    nikhilshinde0909/lncconserve bpipe run -n 16 /pipeline/LncConserve/Main.groovy /pipeline/data.txt
```

8. Export your results to local as follows
```# list containers
docker ps -a

# Copy data
docker cp container_id:/pipeline ${path to copy resuls}
```

## Thanks for using LncConseve !!
