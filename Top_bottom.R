rm(list = ls())
library(reshape2)

#TF_list <- c(read.delim("TF_list_TB.txt",header = F,sep = "\t"))
chip_list <- read.delim("chip_list", header = F, sep = "\t")
selex_list <- read.delim("selex_result/selex_list", header = F, sep = "\t")
TF_list <- unique(rbind(chip_list,selex_list))
write.csv(TF_list,file = "tb_TF_list.csv", row.names = F, quote = F)
##top-bottom
chip_tb_raw <- unique(read.delim("chip_tb/chip_promoter",sep = "\t",header = F))
chip_tb_raw <- chip_tb_raw[,-2]
chip_tb <- c()
for (i in TF_list$V1){
  x <- chip_tb_raw[which(chip_tb_raw$V3==i),]
  chip_tb <- rbind(chip_tb,x)
}
colnames(chip_tb) <- c("top","bottom")
selex_tb_raw <- read.delim("selex_result/selex_result_promoter",header = F, sep = "\t")
selex_tb_raw <- unique(selex_tb_raw[,-3])
selex_tb <- c()
for (i in TF_list$V1){
  x <- selex_tb_raw[which(selex_tb_raw$V2==i),]
  selex_tb <- rbind(selex_tb,x)
}
names(selex_tb) <- c("top","bottom")
all_tb <- rbind(chip_tb, selex_tb)
all_tb <- unique(all_tb)
write.csv(all_tb,file = "all_tb.csv", row.names = F, quote = F)

top_count <- as.data.frame(table(all_tb$top))
names(top_count) <- c("TF", "top")
bottom_count <- as.data.frame(table(all_tb$bottom))
names(bottom_count) <- c("TF", "bottom")
count <- merge(top_count,bottom_count, all = T)
count[is.na(count)] <- 0
colnames(count) <- c("TF","top","bottom")
count$index <- (count$top-count$bottom)/(count$top+count$bottom)
hist(count$index,col='blue',border='yellow',main='',xlab='')
write.csv(count, file = "all_tb_index.csv",quote = F, row.names = F)
count_cutoff10 <- count[which(count$top+count$bottom >= 10),]
hist(count_cutoff10$index,col='blue',border='yellow',main='',xlab='')
write.csv(count_cutoff10, file = "cutoff10_tb_index.csv",quote = F, row.names = F)

top_TF <- count_cutoff10[which(count_cutoff10$index>=0.75),]
middle_TF <- count_cutoff10[which(count_cutoff10$index<=0.75 & count_cutoff10$index >=-0.75),]
bottom_TF <- count_cutoff10[which(count_cutoff10$index<=-0.75),]

tb_cutoff <- all_tb[which(all_tb$top%in%count_cutoff10$TF),]
tb_cutoff <- tb_cutoff[which(tb_cutoff$bottom%in%count_cutoff10$TF),]
write.csv(tb_cutoff,file = "tb_cutoff10.csv", row.names = F, quote = F)
tb_cutoff_edge <- tb_cutoff
tb_cutoff_edge$edge <- 0
for (i in 1:1045) {
  if(tb_cutoff$top[i] %in% bottom_TF$TF & tb_cutoff$bottom[i] %in% middle_TF$TF){
    tb_cutoff_edge$edge[i] <- 1
  }
  else if(tb_cutoff$top[i] %in% middle_TF$TF & tb_cutoff$bottom[i] %in% top_TF$TF){
    tb_cutoff_edge$edge[i] <- 1
  }
  else if(tb_cutoff$top[i] %in% bottom_TF$TF & tb_cutoff$bottom[i] %in% top_TF$TF){
    tb_cutoff_edge$edge[i] <- 1
  }
}
write.csv(tb_cutoff_edge,file = "tb_cutoff10_edge.csv", row.names = F, quote = F)

all_tb$value <- 1

test <- dcast(all_tb, top~bottom)
test[is.na(test)] <- 0
rownames(test) <- test$top
test <- test[,-1]
#write.csv(test, file = "tb_matrix.csv",row.names = F, quote = F)
test$sum <- rowSums(test)
test_10 <- test[which(test$sum>10),]
test_10 <- test_10[,-197]

pheatmap(test_10,
         show_rownames = F,show_colnames = F,
         cluster_rows = T,cluster_cols = T,
         colors <- colorRampPalette(c("#ffffd4", "#bd0026"))(2))
