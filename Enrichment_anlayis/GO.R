rm(list = ls())

library(clusterProfiler)
library(enrichplot)
library(ggnewscale)
library(ggupset)

PA_go <- read.delim("PAO1_gene_ontology_tab.txt",header=T,sep="\t")
PAgo_term2gene <- as.data.frame(PA_go[, c(5,1)])
PAgo_term2name <- as.data.frame(PA_go[, c(5,6)])

#write.csv(y,file = "none.csv", row.names = F, quote = F)
none <- read.csv("./none.csv",header = T)
none[1,] <- "none"
TF_list <- list.files("chip-result/PA-TF/")
for(s in TF_list){
  tf <- read.delim(paste("final.csv/annotation/",s,sep=""),
                   sep=",",header=F)
  tf <- tf[-1, ]
  tf <- tf[which(tf$V13=="upstream"|tf$V13=="overlapStart"),]
  tf <- tf[as.numeric(tf$V7)>=5,]
  gene <- as.factor(tf$V18)
  x <- enricher(gene, TERM2GENE = PAgo_term2gene, TERM2NAME = PAgo_term2name, pvalueCutoff = 0.05)
  y <- rbind(as.data.frame(x),none)
  y$TF <- unlist(strsplit(s,"_"))[1]
  write.csv(y, file = paste(s,"_GO.csv",sep=""),quote=FALSE, row.names=FALSE)
}  
