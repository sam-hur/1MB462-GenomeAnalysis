# https://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html

# -- Dependencies
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# BiocManager::install("DESeq2")
# BiocManager::install("GenomicFeatures")
# BiocManager::install("apeglm")
# BiocManager::install("pheatmap")
# BiocManager::install("vsn")
library(DESeq2)
library(GenomicFeatures)
library(stringr)
library(kableExtra)
library(pheatmap)
library(ggplot2)
library(vsn)
library(purrr)
library(tibble)
library(reshape2)
# --
directory <- "A:/GenomeAnalysis/read_counts/htseq2/"
# --

files <- grep("*", list.files(directory), value=T)
names <- str_extract(files, "ERR[0-9]+")
cond <- sub(".*_(.*?)_.*", "\\1", files)

sampleTable <- data.frame(
  sampleName = names,
  fileName = files,
  condition = factor(cond)
)

htSeq <- DESeqDataSetFromHTSeqCount(
  sampleTable = sampleTable,
  directory = directory,
  design = ~ condition
)

htSeq$condition
colData(htSeq)["condition"] <- factor(c(rep("BHI", 3), rep("Serum", 3)))  # BHI is listed as BH, so this is a fix


dds <- DESeq(htSeq)
dds <- dds[rowSums(counts(dds, normalized=F)) >= 10, ]
colData(dds)

read_counts <- counts(dds, normalized = FALSE)

# By default, R will choose a reference level for factors based on alphabetical order
# Explicitly set reference level so BHI is compared against Serum ():
dds$condition <- relevel(dds$condition, ref = "BHI") 

# result summary from DESeq
resultsNames(dds)  # used to get the condition name
res <- results(dds, contrast = c("condition", "BHI", "Serum"), alpha = 0.05)
summary(res)



# plot results
plotMA(res, cex=0.75, main = "MA Plot of DESeq results")
abline(h=c(-1,1), col="dodgerblue", lwd=2)
legend("topright", legend = c("Significant (padj < 0.05)", "Not Significant"), 
       col = c("blue", "grey"), pch = 16, cex = 1.5)


# extract significant genes
# for this, we want the top expressed L2FC DE genes AND the lowest L2FC DE genes
# Then, plot filtered results
sig <- subset(res, padj < 0.05 & abs(log2FoldChange) > 1) # keep only the v. significant results
head(sig, 10)
summary(sig)
plotMA(sig, cex=0.75, main = "MA Plot of DESeq results (filtered padj < 0.05)")
abline(h=c(-1,1), col="red", lwd=2)
legend("topright", legend = c("Significant (padj < 0.05)", "Not Significant"), 
       col = c("blue", "grey"), pch = 16, cex = 1.5)

### Shrink results based on L2FC
is(dds, "DESeqDataSet")

resLFC <- lfcShrink(dds, coef="condition_Serum_vs_BHI", type="apeglm")
summary(resLFC)

resLFC <- resLFC[resLFC$pvalue < 0.05, ]  # keep only sig values
resLFCOrdered <- resLFC[order(resLFC$pvalue),]  # order by pvalue
summary(resLFC)

# order resLFC

upreg <- rownames(resLFC[order(-resLFC$log2FoldChange),])[1:15]
downreg <- rownames(resLFC[order(resLFC$log2FoldChange),])[1:15]

top_genes <- c(upreg, downreg)

# For Differential Expression Analysis: Use normalized counts (ntd).
# DESeq2 handles the normalization internally during the differential expression analysis process
# resLFC already contains computed statistics that do not require further normalization.
ntd <- normTransform(dds)

matrix <- assay(ntd)[top_genes,]
matrix


annotation <- as.data.frame(colData(dds)[, "condition", drop = FALSE])
# add a type condition, which is rep as we only have 1 type
annotation["type"] <- factor(rep("paired-end", 6)) 
annotation

pheatmap(
  matrix, 
  cluster_rows=T, 
  show_rownames=T,
  cluster_cols=T,
  annotation_col = annotation
)

# to csv

write.csv(matrix, "top_genes.csv")
?write.csv

cnts <- as.data.frame(read_counts[rownames(read_counts) %in% top_genes, ])
cnts

df <- data.frame(Gene=rownames(cnts), Frequency=rowSums(cnts), row.names = NULL)
df

cnts_per_treatment <- as.data.frame(cnts[rownames(cnts) %in% top_genes, ])

head(cnts_per_treatment, 10)
df_treatment <- as.data.frame(cnts[])


colnames(cnts_per_treatment) <- c("BHI1", "BHI2", "BHI3", "Serum1", "Serum2", "Serum3")
bhi <- rowSums(cnts_per_treatment[, grepl("BHI", colnames(cnts_per_treatment))])
serum <- rowSums(cnts_per_treatment[, grepl("Serum", colnames(cnts_per_treatment))])
cnts_per_treatment
cnts_per_treatment <- data.frame(
  Gene = rownames(cnts_per_treatment),
  BHI = bhi,
  Serum = serum,
  row.names = NULL
)

read_counts
colnames(read_counts) <- c("BHI1", "BHI2", "BHI3", "Serum1", "Serum2", "Serum3")
bhi <- rowSums(read_counts[, grepl("BHI", colnames(read_counts))])
serum <- rowSums(read_counts[, grepl("Serum", colnames(read_counts))])
cnts_all <- data.frame(
  Gene= rownames(read_counts),
  BHI = bhi,
  Serum = serum,
  row.names = NULL 
)

cnts_all

cnts_per_treatment

# Create the bar plot
plt <- ggplot(cnts_per_treatment, aes(x = Gene)) +
  geom_bar(aes(y = BHI, fill = "BHI"), stat = "identity", position = "stack") +
  geom_bar(aes(y = Serum, fill = "Serum"), stat = "identity", position = "stack") +
  labs(title = "Sum of Read Counts for Each Gene by Condition",
       x = "Gene",
       y = "Sum of Read Counts",
       fill = "Condition") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        plot.title = element_text(hjust = 0.5, size = 22, margin = margin(t=20, b=20)))

ggsave("top_genes_hist.png", plt)
plt

plt_all <- ggplot(cnts_all, aes(x = Gene)) +
  geom_bar(aes(y = BHI, fill = "BHI"), stat = "identity", position = "stack") +
  geom_bar(aes(y = Serum, fill = "Serum"), stat = "identity", position = "stack") +
  labs(title = "Sum of Read Counts for Each Gene by Condition",
       x = "Gene",
       y = "Sum of Read Counts",
       fill = "Condition") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, size = 22, margin = margin(t = 20, b = 20)),
        axis.text.x = element_blank(),  # Hide x-axis text
        axis.ticks.x = element_blank()) +  # Hide x-axis ticks
  ylim(0, 6.5e+05)  # Set y-axis limit
  
plt_all

ggsave("top_genes_hist.png", plt)
ggsave("all_genes_hist.png", plt_all)
