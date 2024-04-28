install.packages("useful")
library(useful)

count_df <- read.csv("Integrated_scaled_counts_release.txt", header=TRUE) 

set.seed(54612024)
num_clusters = 30

kmeans_result <- kmeans(count_df[-1, -1], num_clusters)
plot(kmeans_result)
print(kmeans_result)

# hierarchical clustering
hierarchical_result <- hclust(dist(count_df))
plot(hierarchical_result)
# agglomerative nesting
agnes_result <- agnes(count_df)
plot(agnes_result, which.plots=2)
# PCA
pca_result <- prcomp(count_df, scale. = FALSE)
# ADD CODE TO PLOT HERE
