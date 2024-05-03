cat ./sampleID|while read i;
do cat ./sampleID|while read j;
do bedtools intersect -a ./bed/${i}.bed -b ./bed/${j}.bed -wo |awk '{print $7}'> ${i}_${j}_interect.bed;
done;
done 
