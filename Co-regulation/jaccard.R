##upload libraries
library(pheatmap)
library(RColorBrewer)
library(pals)
library(ggpubr)
library(UpSetR)
library(reshape2)
library(ggsci)

rm(list = ls())

matrix <- read.csv("Jaccard.csv", header = T)
matrix <- matrix[,-1]
names <- as.character(t(read.delim("sampleID", header = F)))
colnames(matrix) <- names
rownames(matrix) <- names
annotation <- read.csv("D:/CityU/Projects/PA-ChIP-seq/jaccard/TF_family_all.csv", header = T)
colnames(annotation) <- c("TF","DBD_type")

matrix1 <- pheatmap(log1p(matrix), silent = T)
matrix2 <- log1p(matrix)[matrix1$tree_row$labels[matrix1$tree_row$order],
                         matrix1$tree_row$labels[matrix1$tree_row$order]]
matrix3 <- log1p(matrix)[matrix1$tree_row$labels[matrix1$tree_row$order],
                         matrix1$tree_row$labels[matrix1$tree_row$order]]
diag(matrix2) <- matrix2[upper.tri(matrix2)] <- -0.001

col <- as.data.frame(colnames(matrix2))
names(col) <- "TF"
annotation_col <- merge(col,annotation, by = "TF", all.x = T )
a <- annotation_col$TF
annotation_col <- as.data.frame(annotation_col[,-1])
colnames(annotation_col) <- "DBD_type"
rownames(annotation_col) <- a

fcols <- colorRampPalette(brewer.pal(n=8, name="Set1"))(length(unique(annotation_col$DBD_type)))
names(fcols) <- unique(annotation_col$DBD_type)
ann_colors <- list(DBD_type=fcols)
pdf(file = "matrix_2.pdf", height = 10, width = 10)
pheatmap(matrix2, cellwidth=3, cellheight=3, fontsize=5, 
         border_color = NA, fontsize_col = 3,
         cluster_rows = F, cluster_cols = F,
         annotation_col = annotation_col,show_rownames = F,
         annotation_colors=ann_colors,annotation_legend = T,
         legend_breaks = seq(0, 0.5, 0.25), legend_labels = c("0", "0.25", "0.5"),
         color=c("white",brewer.ylorrd(255)))
dev.off()
write.csv(matrix2, file = "jaccard_matrix2.csv")

master_matrix <- matrix2[c(2:36,38:54,124:162),
                         c(1:35,37:53,123:161)]
col <- as.data.frame(colnames(master_matrix))
names(col) <- "TF"
annotation_col <- merge(col,annotation, by = "TF", all.x = T )
a <- annotation_col$TF
annotation_col <- as.data.frame(annotation_col[,-1])
colnames(annotation_col) <- "DBD_type"
rownames(annotation_col) <- a

fcols <- colorRampPalette(brewer.pal(n=8, name="Set1"))(length(unique(annotation_col$DBD_type)))
names(fcols) <- unique(annotation_col$DBD_type)
ann_colors <- list(DBD_type=fcols)

pdf(file = "master_matrix.pdf", height = 6, width = 6)
pheatmap(master_matrix, cellwidth=3, cellheight=3, fontsize=5, 
         border_color = NA, fontsize_col = 3,
         cluster_rows = F, cluster_cols = F,show_rownames = F,
         annotation_col = annotation_col,
         annotation_colors=ann_colors,annotation_legend = T,
         legend_breaks = seq(0, 0.5, 0.25), legend_labels = c("0", "0.25", "0.5"),
         color=c("white",brewer.ylorrd(255)))
dev.off()
dev.new()

FleQ <- as.data.frame(colnames(matrix2[124:162, 123:161]))


library(tidyverse)  # data manipulation
library(cluster)    # clustering algorithms
library(factoextra) # clustering algorithms & visualization

#Elbow method
# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(matrix, k, nstart = 10 )$tot.withinss
}
# Compute and plot wss for k = 1 to k = 15
k.values <- 1:15
# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, frame = FALSE, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares")

fviz_nbclust(matrix3, kmeans, method = "wss")
fviz_nbclust(matrix3, kmeans, method = "silhouette")
gap_stat <- clusGap(matrix3, FUN = kmeans, nstart = 25,
                    K.max = 10, B = 50)
fviz_gap_stat(gap_stat)

matrix3 %>%
  mutate(Cluster = final_4$cluster) %>%
  group_by(Cluster) %>%
  summarise_all("mean")



