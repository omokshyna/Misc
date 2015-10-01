set.seed(5)

y <- rnorm(100, 5, 1)
y <- as.factor(rbinom(100, 1, 0.7))

create.folds <- function(y, k = 10, random = F, returnTrain = F) {
  
#   y <- sort(y)
  
  if (is.numeric(y)) {
    cuts <- round(length(y)/k)
    y <- cut(y, unique(quantile(y, probs = seq(0, 1, length = cuts))), 
               include.lowest = TRUE)

  } 
  
  numClasses <- table(y)
  foldVector <- vector("integer", length(y))
  if (!random) {
    for (i in 1:length(numClasses)) {
        seqVector <- rep(1:k, numClasses[i]%/%k)
        suppressWarnings(foldVector[which(y == dimnames(numClasses)$y[i])] <- seqVector)
      }
  } else {
    set.seed(length(y))
    for (i in 1:length(numClasses)) {
      seqVector <- rep(1:k, numClasses[i]%/%k)
      seqVector <- c(seqVector, sample(1:k, numClasses[i]%%k))
      foldVector[which(y == dimnames(numClasses)$y[i])] <- sample(seqVector)
    }
  }   
  
  out <- split(seq(y), foldVector)
  names(out) <- paste("Fold", as.character(seq(out)), sep = "")
  
  if (returnTrain) {
    out <- lapply(out, function(data, y) y[-data], y = seq(y))  
  }
    
  return(out)
    
  }
  