cd 01rawdata
trim_galore -q 20 --phred33 --length 20 --stringency 3 --paired R1.fastq.gz R2.fastq.gz --fastqc -o ../02cleandata
