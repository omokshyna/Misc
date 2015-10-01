
x <- local(get(load(paste(wdir, "data/sol_x1.RData", sep = ''))))
y <- local(get(load(paste(wdir, "data/sol_y1.RData", sep = ''))))

require(caret)
require(doParallel)

registerDoParallel(3)


preProc <- preProcess(x, method = c("scale", "center"))
x <- predict(preProc, x)

set.seed(42)
cv <- createFolds(y, 5, returnTrain = T)
trControl <- trainControl(method = "LGOCV",
                          index = cv, 
                          savePredictions = T,
                          preProcOptions = NULL)

plsGrid <- data.frame(ncomp= 5)
m.pls <- train(x, y, 
               method = "pls",
               trControl = trControl,
               tuneGrid = plsGrid)

knnGrid <- data.frame(k=seq(1,20,2))
m.knn <- train(x, y, 
               method="knn",
               trControl=trControl,
               tuneGrid=knnGrid)

rfGrid <- data.frame(mtry = c(100, 500, 1000))
m.rf <- train(x, y, 
              method = "rf",
              trControl = trControl,
              tuneGrid = rfGrid,
              importance = TRUE)

m.gbm <- train(x, y,
               method = "gbm",
               trControl = trControl)

svmGrid <- expand.grid(C=c(10, 20, 50, 100), sigma=10^-(3:7))
m.svm <- train(x, y,
               method = "svmRadial",
               trControl = trControl,
               tuneGrid = svmGrid)
save(m.gbm, file = "models/sol1_gbm.RData")
save(m.knn, file = "models/sol1_knn.RData")
save(m.pls, file = "models/sol1_pls.RData")
save(m.rf, file = "models/sol1_rf.RData")
save(m.svm, file = "models/sol1_gbm.RData")

#Calculation of consensus prediction for cv
m.gbm <- local(get(load(paste(wdir, "models/sol1_gbm.RData", sep = ''))))
m.knn <- local(get(load(paste(wdir, "models/sol1_knn.RData", sep = ''))))
m.pls <- local(get(load(paste(wdir, "models/sol1_pls.RData", sep = ''))))
m.rf <- local(get(load(paste(wdir, "models/sol1_rf.RData", sep = ''))))
m.svm <- local(get(load(paste(wdir, "models/sol1_svm.RData", sep = ''))))

y <- local(get(load(paste(wdir, "data/sol_y1.RData", sep = ''))))

getCV <- function(caret.model) {
  df <- caret.model$pred
  best <- caret.model$bestTune
  ids <- apply(df[, names(best), drop = FALSE], 1, function(r) all(r == best[1, ]))
  df <- df[ids, ]
  df <- df[order(df$rowIndex), c("pred")]
  return(df)
}

named.list <- function(...) {
  names <- as.list(substitute(list(...)))[-1]
  setNames(list(...), names)
}

models.list <- named.list(m.gbm, m.knn, m.pls, m.rf, m.svm)
cv.pred <- as.data.frame(sapply(models.list, getCV))
head(cv.pred)

cv.pred$mean <- rowMeans(cv.pred)
head(cv.pred)

R2test <- function(ts.pred, ts.obs, ws.obs.mean = mean(ts.obs)) {
  return(1 - sum((ts.pred - ts.obs)**2)/sum((ts.obs - ws.obs.mean)**2))
}

cv.rmse <- sapply(cv.pred, Metrics::rmse, y)
cv.r2 <- sapply(cv.pred, cor, y) ^ 2
cv.r2test <- sapply(cv.pred, R2test, y)
cv.rmse <- round(cv.rmse, 3)
cv.r2 <- round(cv.r2, 3)
cv.r2test <- round(cv.r2test, 3)

cv.res <- as.data.frame(rbind(cv.rmse, cv.r2, cv.r2test))
cv.res
