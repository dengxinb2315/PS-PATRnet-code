rm(list = ls())

library(clusterProfiler)
library(enrichplot)
library(ggnewscale)
library(ggupset)

PA_kegg <- read.csv("pathways.csv", header = T)
PAkegg_term2gene <- as.data.frame(PA_kegg[, c(4,1)])
PAkegg_term2name <- as.data.frame(PA_kegg[, c(4,3)])

none <- read.csv("../GO/none.csv",header = T)
none[1,] <- "none"
TF_list <- list.files("chip-result/PA-TF/")

for(s in TF_list){
  tf <- read.delim(paste("final.csv/annotation/",s,sep=""),
                   sep=",", header = F)
  tf <- tf[-1, ]
  tf <- tf[which(tf$V13=="upstream"|tf$V13=="overlapStart"),]
  gene <- as.factor(tf$V18)
  x <- enricher(gene, TERM2GENE = PAkegg_term2gene, TERM2NAME = PAkegg_term2name, pvalueCutoff = 0.05)
  y <- rbind(as.data.frame(x),none)
  y$TF <- unlist(strsplit(s,"_"))[1]
  write.csv(y, file = paste(s,"_kegg.csv",sep=""),quote=FALSE, row.names=FALSE)
} 
