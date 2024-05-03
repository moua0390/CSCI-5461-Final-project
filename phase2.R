# Supervised learning classifier — K-Nearest Neighbors

if (!require("class")) {
  install.packages("class")
  library(class)
}

set.seed(54612024)

supervised_snc_classifier <- function(train, test, train_scores, k=5, output_file="phase2_predictions.txt") {
  # Transpose data in order to cluster by cell
  train_transpose <- t(train[,-1])
  test_transpose <- t(test[,-1])

  # Perform K-Nearest Neighbors classification
  score <- knn(train_transpose, test_transpose, train_scores, k)

  # Record test scores for each cell
  test_scored <- t(data.frame(score, row.names=rownames(test_transpose)))
  write.csv(test_scored, output_file, row.names=FALSE, quote=FALSE)
  
  # Evaluate performance using cross validation on the test set.
  # Then compare test scores to cross validation scores.
  cv_score <- knn.cv(test_transpose, score, k)
  accuracy <- mean(cv_score == score)
  cat("Supervised Model Accuracy (k=", k, "): ", accuracy, sep="")
  
  return (test_scored)
}
