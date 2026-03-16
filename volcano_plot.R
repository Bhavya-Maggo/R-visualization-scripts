# Load libraries
library(ggplot2)
library(ggrepel)

# Read files
df <- read.csv ("file1.csv")
df <- na.omit(df)
colnames (df)

# Selecting column
df <- df[, c("genes", "logFC", "PValue")]
colnames (df)

# Volcano Plot Workflow
# 1. Add a column indicating Up/Down/Not significant
df$diffexpressed <- "NO"
df$diffexpressed[df$logFC > 0.6 & df$PValue < 0.05] <- "UP"
df$diffexpressed[df$logFC < -0.6 & df$PValue < 0.05] <- "DOWN"
table (df$diffexpressed)

# 2. Label genes
# 2.1. Label top 30 significant genes
df$label <- ifelse(df$genes %in% head(df[order(df$PValue), "genes"], 30), df$genes, NA)
colnames (df)
####OR#####
# 2.2. Label all genes
df$label <- df$genes
colnames (df)

# 3. Volcano plot
volcano <- ggplot(df, aes(x = logFC, y = -log10(PValue), color = diffexpressed)) +
  geom_point(size = 2) +  # larger points
  geom_vline(xintercept = c(-0.6, 0.6), linetype = "dashed", color = "black") +
  geom_hline(yintercept = -log10(0.05), linetype = "dashed", color = "black") +
  geom_text_repel(aes(label = label), max.overlaps = Inf, size = 3) +
  scale_color_manual(values = c("DOWN" = "blue", "NO" = "grey", "UP" = "red")) +
  coord_cartesian(ylim = c(0, 250), xlim = c(-10, 10)) +
  labs(x = "log2 Fold Change", y = "-log10(p-value)", color = "Expression") +
  ggtitle("Volcano Plot")

# 4. Show the plot
volcano

# 5. Save the plot
ggsave("volcano_plot.png", plot = volcano, width = 8, height = 6, dpi = 600)

