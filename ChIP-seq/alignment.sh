#Build Reference
bowtie2-build -f reference PS

#alignment
bowtie2 -p 20 -x ../reference/PS -1 ../02cleandata/R1_val_1.fq.gz -2 ../02cleandata/R2_val_2.fq.gz -S sample.sam 2>sample.align.log
