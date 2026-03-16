# Load pheatmap library
library (ggplot2)
library(pheatmap)
library(grid) 

# Load file
df <- read.csv ("file1.csv")

# Select top 50 genes by FDR
df <- df[order(df$FDR), ][1:50, ]

# Select columns
df <- df[, c( "genes", "Ba1", "Ba2", "Ba3", "B1", "B2", "B3")]

# Set gene names as row names
rownames(df) <- df$genes

# Remove gene column
df$genes <- NULL

# Ensure all values are numeric
df[,] <- lapply(df, as.numeric)
df <- as.matrix(df)
View (df)

# Create custom color palette
my_colors <- colorRampPalette(c("#762A83", "#FFFFFF", "#1B7837"))(100) 

# Creating heatmap
heatmap <- pheatmap(df, 
         scale = "row", 
         show_rownames = TRUE,
         show_colnames = TRUE,
         #cellheight = 10,    # increase row height
         fontsize = 7, 
         cluster_rows = F, 
         cluster_cols = F,
         clustering_distance_rows = "euclidean", 
         clustering_distance_cols = "euclidean",
         col = my_colors)

# Save plot 
ggsave("heatmap.png", 
       plot = grid::grid.grabExpr(grid::grid.draw(heatmap$gtable)),
       width = 8, 
       height = 6, 
       dpi = 600)
