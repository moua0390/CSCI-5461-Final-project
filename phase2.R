# Supervised learning classifier — K-Nearest Neighbors

library(class)

set.seed(54612024)

supervised_snc_classifier <- function(train, test, k=5) {
  # Retrieve SnC scores from training data
  train_scores <- train$score

  # Remove non-numeric columns
  train_filtered <- Filter(is.numeric, train[, colnames(train)[colnames(train) != "score"]])
  test_filtered <- Filter(is.numeric, test)

  # Perform K-Nearest Neighbors classification
  score <- knn(train_filtered, test_filtered, train_scores, k)

  # Append test scores to the test data set
  test_scored <- cbind(test, score)

  return (test_scored)
}
