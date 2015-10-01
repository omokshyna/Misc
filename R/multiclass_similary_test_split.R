#-------------------------------------------------------------------------------
# Name:        	multiclass_sim_test_split
# Purpose:     	Create balanced training and external test sets based on compounds' diversity
#				(Peter Willett. Journal of Computational Biology. 
#				October 1999, 6(3-4): 447-457. doi:10.1089/106652799318382)
#
# Author:      	Olena Mokshyna
#
# Created:     	11.12.2014
#-------------------------------------------------------------------------------
#


#setwd("")

X <- local(get(load("_example_data/x_oecd.RData")))
y <- local(get(load("_example_data/y.RData")))

set.seed(24)

#get the cases from the smallest class
y1 <- y
inds <- which(table(y) == min(table(y)), arr.ind = T)
x1 <- X[which(y1 != names(table(y)[inds])),]
x2 <- X[which(y1 == names(table(y)[inds])),]

y1a <- droplevels(y1[which(names(y) %in% rownames(x1))])

x1.test.diss <- NULL
x1.train.diss <- NULL

#check
# for (level in levels(y1a)) {
#   print(level)
# }

require(caret)

for (level in levels(y1a)) {
  x1a <- x1[which(y1a == level),]
  
  startSet <- sample(1:nrow(x1a), 5)
  
  x1.test.dissW <- x1a[startSet, ]
  x1.train.dissW <- x1a[-startSet, ]
  
  n <- round((dim(x1a)[1] - dim(x2)[1])/2)
  
  #for minimum dissimilarity
  newSamples <- minDissim(x1.test.dissW, x1.train.dissW, n, 
                          randomFrac = 0.1)
  
  
  x1.test.dissW <- rbind(x1.test.dissW, x1.train.dissW[newSamples,])
  x1.train.dissW <- x1.train.dissW[-newSamples,]
  
  #get other 50% random of ts
  randomSamples <- sample(1:nrow(x1.train.dissW), n)
  
  x1.test.dissW <- rbind(x1.test.dissW, x1.train.dissW[randomSamples,])
  x1.train.dissW <- x1.train.dissW[-randomSamples,]
  
  #bind with previous iteration
  x1.train.diss <- rbind(x1.train.diss, x1.train.dissW)
  x1.test.diss <- rbind(x1.test.diss, x1.test.dissW)
}

#bind negative and positive in the training set
x1.train.diss <- rbind(x1.train.diss, x2)  

#get y for the training and test sets
y1.train.diss <- y[rownames(x1.train.diss)]
y1.test.diss <- y[rownames(x1.test.diss)]


#Save data
save(y1.test.diss, file = "03_RData/oecd/y1.test.diss.RData")
save(x1.test.diss, file = "03_RData/oecd/x1.test.diss.RData")
save(y1.train.diss, file = "03_RData/oecd/y1.train.diss.RData")
save(x1.train.diss, file = "03_RData/oecd/x1.train.diss.RData")

###########################################
# minDissim - modified maxDissim from caret
###########################################

minDissim <- function (a, b, n = 2, obj = minDiss, useNames = FALSE, randomFrac = 1, 
                       verbose = FALSE, ...) 
{
  library(proxy)
  if (nrow(b) < 2) 
    stop("there must be at least 2 samples in b")
  if (ncol(a) != ncol(b)) 
    stop("a and b must have the same number of columns")
  if (nrow(b) < n) 
    stop("n must be less than nrow(b)")
  if (randomFrac > 1 | randomFrac <= 0) 
    stop("randomFrac must be in (0, 1]")
  if (useNames) {
    if (is.null(rownames(b))) {
      warning("Cannot use rownames; swithcing to indices")
      free <- 1:nrow(b)
    }
    else free <- rownames(b)
  }
  else free <- 1:nrow(b)
  inSubset <- NULL
  newA <- a
  if (verbose) 
    cat("  adding:")
  for (i in 1:n) {
    pool <- if (randomFrac == 1) 
      free
    else sample(free, max(2, floor(randomFrac * length(free))))
    if (verbose) {
      cat("\nIter", i, "\n")
      cat("Number of candidates:", length(free), "\n")
      cat("Sampling from", length(pool), "samples\n")
    }
    diss <- proxy::dist(newA, b[pool, , drop = FALSE], ...)
    bNames <- colnames(b)[pool]
    tmp <- pool[which.min(apply(diss, 2, obj))]
    if (verbose) 
      cat("new sample:", tmp, "\n")
    inSubset <- c(inSubset, tmp)
    newA <- rbind(newA, b[tmp, , drop = FALSE])
    free <- free[!(free %in% inSubset)]
  }
  inSubset
}
