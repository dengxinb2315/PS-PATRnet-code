#get fasta file from macs3
cat $sample_summits.bed |awk '{print $1 "\t" $2-50 "\t" $3+50}' > $sample.bed
bedtools getfasta -fi reference/PS.fna -bed $sample.bed -fo $sample.fasta

#call motif
meme-chip $sample.fasta -maxw 20 -oc $sample
