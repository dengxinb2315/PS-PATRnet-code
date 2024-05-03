#Build Reference
bowtie2-build -f reference PS

#alignment
bowtie2 -p 20 -x ../reference/PS -1 ../02cleandata/R1_val_1.fq.gz -2 ../02cleandata/R2_val_2.fq.gz -S $sample.sam 2>$sample.align.log

#sam to bam
samtools sort $sample.unique.sam -@ 20 -o ./$sample.bam

#merge two files
samtools merge $sample.merge.bam $sample-1.bam $sample-2.bam

#remove duplicates
sambamba markdup --overflow-list-size 5928787 --tmpdir ./ -r ./$sample.merge.bam ./$sample.rmdup.bam -t 10
