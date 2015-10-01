setwd("D:/GoogleDrive/Calc/skSens_onfly/!QSAR/_bin_500_comp/04_Models/sirms/test_set/")

#Read LSM descriptors
desc <- readDat("./02_project/all.dat")

#Read property and additional descriptors
dataset <- read.csv("property.csv", header = T, row.names = 1)
dataset <- dataset[rownames(desc),]
rownames(desc) <- dataset$Name
rownames(dataset) <- dataset$Name

#Create x and y
y <- as.factor(dataset$Class)
names(y) <- rownames(dataset) 
# levels(y) <- c("Non", "Sensitizer")
X <- desc
x.OASIS <- cbind(dataset$PB_OASIS, desc)
x.OECD <- cbind(dataset$PB_OECD, desc)

#Save data
save(y, file = "03_data/y.RData")
save(desc, file = "03_data/x_sirms_all.RData")
save(x.OECD, file = "03_RData/x_oecd.RData")
save(x.OASIS, file = "03_RData/x_oasis.RData")


#Load data 
setwd("F:/_MEG/_skSens/_bin_500_comp/")
y <- local(get(load("03_RData/oecd/y1.train.diss.RData")))
X <- local(get(load("03_RData/oecd/x1.train.diss.RData")))

# X <- local(get(load("03_RData/x_oecd.RData")))
# y <- local(get(load("03_RData/y.RData")))

#One-vs-All
# levels(y) <- c("non", "sens", "sens", "sens")

levels(y) <- c("ModerateAndStrong", "NonAndWeak", "ModerateAndStrong", "NonAndWeak")
plot(y)
table(y)
write.table(table(y), file = "04_Models/SB/y_distribution.csv", sep = ",")


#Prepare data 
require(caret)

#Choose only one mechanism
# X <- X[which(X[,1] == "SB"), -1, drop = F]
# y <- y[rownames(X)]

preProc <- preProcess(X[, 2:ncol(X)], method=c("center", "scale"))
# X <- cbind(X[,1], predict(preProc, X[, 2:ncol(X)]))
X <- predict(preProc, X[, 2:ncol(X)])

nzv <- nearZeroVar(X)
X <- X[, -nzv]

dirw <- "04_Models/SB"
save(preProc, file = paste(dirw, "preProc.RData", sep = ''))

# preProc <- preProcess(X, method=c("center", "scale"))
# X <- predict(preProc, X)

#Build model
cv <- createFolds(y, 3, returnTrain = T)
trControl <- trainControl(method = "LGOCV",
                          index = cv, 
                          savePredictions = T,
                          classProbs = T,
                          preProcOptions = NULL)

require(doParallel)
registerDoParallel(4)

c <- NULL

# # knnGrid <- data.frame(k=seq(1,20,2))
# # m.knn <- local(get(load("04_Models/binary_balanced_knn.RData")))
# m.knn <- train(X, as.factor(y), 
#                method="knn",
#                trControl=trControl)
# #                weights = c(1,1,1,4))
# #                tuneGrid=knnGrid)
# cm <- confusionMatrix(getCVProb(m.knn, "pred"), y)
# save(m.knn, file = "04_Models/knn.RData")
# # save(cm, file = "04_Models/mc_knn_cm.RData")
# write.table(as.matrix(cm), file = "04_Models/knn_cm.csv", sep = ",")
# c[["knn"]] <- c(cm$overall, cm$byClass)

# m.rf <- local(get(load("04_Models/binary_balanced_rf.RData")))
rfGrid <- data.frame(mtry = c(100, 200, 500))
m.rf <- train(X, y, 
              method = "rf",
              trControl = trControl,
              importance = TRUE,
#               metrics = "Kappa",
              tuneGrid = rfGrid)
cm <- confusionMatrix(getCVProb(m.rf, "pred"), y)
save(m.rf, file = paste(dirw, "rf.RData", sep = ""))
write.table(as.matrix(cm), file = paste(dirw, "rf_cm.csv", sep=""), sep = ",")
# pred <- m.rf$pred[m.rf$pred$mtry == m.rf$bestTune$mtry,] #extract predictions
pred <- getAllCV(m.rf) #extract predictions
pred.names <- rownames(m.rf$trainingData)[pred$rowIndex]
pred <- cbind(pred, pred.names)
write.table(pred, file = paste(dirw, "rf_pred_fold.csv", sep=""), sep = ",")
c[["rf"]] <- c(cm$overall, cm$byClass)

# m.gbm <- local(get(load("04_Models/binary_balanced_gbm.RData")))
m.gbm <- train(X, y,
               method = "gbm",
               trControl = trControl)
cm <- confusionMatrix(getCVProb(m.gbm, "pred"), y)
save(m.gbm, file = paste(dirw, "gbm.RData", sep = ''))
write.table(as.matrix(cm), file = paste(dirw, "gbm_cm.csv", sep=''), sep = ",")
# pred <- m.gbm$pred[m.gbm$pred$n.trees == m.gbm$bestTune$n.trees & 
#                      m.gbm$pred$shrinkage == m.gbm$bestTune$shrinkage & 
#                      m.gbm$pred$interaction.depth == m.gbm$bestTune$interaction.depth,] #extract predictions
pred <- getAllCV(m.gbm)
pred.names <- rownames(m.gbm$trainingData)[pred$rowIndex]
pred <- cbind(pred, pred.names)
write.table(pred, file = paste(dirw, "gbm_pred_fold.csv", sep=""), sep = ",")
c[["gbm"]] <- c(cm$overall, cm$byClass)

# svmGrid <- expand.grid(C=c(10, 20, 50, 100), sigma=10^-(3:7))
# m.svm <- local(get(load("04_Models/binary_balanced_svmRadial.RData")))
m.svm <- train(X, y,
               method = "svmRadial",
               trControl = trControl,
               classProbs =  TRUE)
#                tuneGrid = svmGrid)
cm <- confusionMatrix(getCVProb(m.svm, "pred"), y)
save(m.svm, file = paste(dirw, "svmRadial.RData", sep = ""))
write.table(as.matrix(cm), file = paste(dirw, "svm_cm.csv", sep=""), sep = ",")
pred <- getAllCV(m.svm)
pred.names <- rownames(m.svm$trainingData)[pred$rowIndex]
pred <- cbind(pred, pred.names)
write.table(pred, file = paste(dirw, "svm_pred_fold.csv", sep=""), sep = ",")
c[["svm"]] <- c(cm$overall, cm$byClass)

#Save parameters for all models
all.final <- do.call(rbind, c)
write.table(all.final, file = paste(dirw, "!final_train_stat.csv", sep=""), sep = ",")

###training set
setwd("F:/_MEG/_skSens/_mc_387_comp/")
dirw <- "04_Models/sirms/"

m.rf <- local(get(load(paste(dirw, "rf.RData", sep = ""))))
m.gbm <- local(get(load(paste(dirw, "gbm.RData", sep = ""))))
m.svm <- local(get(load(paste(dirw, "svmRadial.RData", sep = ""))))

rf.train <- predict(m.rf, m.rf$trainingData)
gbm.train <- predict(m.gbm, m.gbm$trainingData)
svm.train <- predict(m.svm, m.svm$trainingData)

y <- local(get(load("03_Rdata//oecd//y1.train.diss.RData")))
# all(names(y) == names(m.rf$finalModel$y))

rf.trainT <- cbind.data.frame(y, rf.train)
gbm.trainT <- cbind.data.frame(y, gbm.train)
svm.trainT <- cbind.data.frame(y, svm.train)

cm.rf <- confusionMatrix(rf.trainT[,1], rf.trainT[,2])

write.csv(rf.trainT, file = paste(dirw, "rf_trainingFit.csv", sep=''))
write.csv(gbm.trainT, file = paste(dirw, "gbm_trainingFit.csv", sep=''))
write.csv(svm.trainT, file = paste(dirw, "svm_trainingFit.csv", sep=''))

#Predict test set 
setwd("D:/GoogleDrive/Calc/skSens_onfly/!QSAR/_bin_500_comp/")
dirw <- "04_Models/sirms/"

y.test <- local(get(load("04_Models/sirms/test_set/03_data/y.RData")))
X.test <- local(get(load("04_Models/sirms/test_set/03_data/x_sirms_all.RData")))

X.train <- local(get(load("03_RData/oecd/x1.train.diss.RData")))
nzv <- nearZeroVar(X.train)
X.train <- X.train[, -nzv]
X.train <- X.train[,2:ncol(X.train)]

levels(y.test) <- c("ModerateAndStrong", "NonAndWeak", "ModerateAndStrong", "NonAndWeak")
#check if all descriptors are the same
all(intersect(names(X.train), names(X.test)) == intersect(names(X.test), names(X.train)))

#add absent descriptors as 0s
namesAbsent <- colnames(X.train)[-(which(colnames(X.train) %in% colnames(X.test)))]
X.test[, namesAbsent] <- 0

X.test <- X.test[,which(colnames(X.test) %in% colnames(X.train))]

preProc <- local(get(load(file = paste(dirw, "preProc.RData", sep = ''))))

m.rf <- local(get(load("04_Models/sirms/rf.RData")))
m.gbm <- local(get(load("04_Models/sirms/gbm.RData")))
m.svm <- local(get(load("04_Models/sirms/svmRadial.RData")))

# X.test <- predict(preProc, X.test)
X.test <- X.test[, -which(colnames(X.test) %in% "dataset$PB_OECD")]
X.test <- predict(preProc, X.test)
# X.test <- X.test[, colnames(m.rf$trainingData)]
levels(y.test) <- c("Non", "Sensitiser")
# y.pred.knn <- predict(m.knn, X.test, type="raw")
# confusionMatrix(y.pred.knn, y.test)
# c1 <- NULL
# c2 <- NULL
c <- NULL

y.pred.rf <- predict(m.rf, X.test, type="raw")
y.pred.rf.prob <- predict(m.rf, X.test, type="prob")
names(y.pred.rf) <- names(y.test)
rownames(y.pred.rf.prob) <- names(y.test)
levels(y.pred.rf) <- c("Sensitiser", "Non", "Sensitiser", "Sensitiser")
y.pred.rf <- factor(y.pred.rf, levels(y.pred.rf)[c(2,1)])
cm <- confusionMatrix(y.pred.rf, y.test)
write.table(y.pred.rf, file = paste(dirw, "test_set/y_pred_rf.csv", sep=''), sep = ",")
write.table(y.pred.rf.prob, file = paste(dirw, "test_set/y_pred_rf_prob.csv", sep=''), sep = ",")
# c1[['rf']] <- cm$overall
# c2[['rf']] <- cm$byClass
c[["rf"]] <- c(cm$overall, cm$byClass)

y.pred.gbm <- predict(m.gbm, X.test, type="raw")
y.pred.gbm.prob <- predict(m.gbm, X.test, type="prob")
names(y.pred.gbm) <- names(y.test)
rownames(y.pred.gbm.prob) <- names(y.test)
levels(y.pred.gbm) <- c("Sensitiser", "Non", "Sensitiser", "Sensitiser")
y.pred.gbm <- factor(y.pred.gbm, levels(y.pred.gbm)[c(2,1)])
cm <- confusionMatrix(y.pred.gbm, y.test)
write.table(y.pred.gbm, file = paste(dirw, "test_set/y_pred_gbm.csv", sep=''), sep = ",")
write.table(y.pred.gbm.prob, file = paste(dirw, "test_set/y_pred_gbm_prob.csv", sep=''), sep = ",")
# c1[['gbm']] <- cm$overall
# c2[['gbm']] <- cm$byClass
c[["gbm"]] <- c(cm$overall, cm$byClass)

y.pred.svm <- predict(m.svm, X.test, type="raw")
y.pred.svm.prob <- predict(m.svm, X.test, type="prob")
names(y.pred.svm) <- names(y.test)
rownames(y.pred.svm.prob) <- names(y.test)
levels(y.pred.svm) <- c("Sensitiser", "Non", "Sensitiser", "Sensitiser")
y.pred.svm <- factor(y.pred.svm, levels(y.pred.svm)[c(2,1)])
cm <- confusionMatrix(y.pred.svm, y.test)
write.table(y.pred.svm, file = paste(dirw, "test_set/y_pred_svm.csv", sep=''), sep = ",")
write.table(y.pred.svm.prob, file = paste(dirw, "test_set/y_pred_svm_prob.csv", sep=''), sep = ",")
# c1[['svm']] <- cm$overall
# c2[['svm']] <- cm$byClass
c[["svm"]] <- c(cm$overall, cm$byClass)

all.final <- do.call(rbind, c)
# all1.final <- do.call(rbind, c1)
# all2.final <- do.call(rbind, c2)
write.table(all.final, file = paste(dirw, "test_set/!final_test_stat.csv", sep=''), sep = ",")
# write.table(all1.final, file = paste(dirw, "!final_test_stat_overall.csv", sep=''), sep = ",")
# write.table(all2.final, file = paste(dirw, "!final_test_stat_byClass.csv", sep=''), sep = ",")

##############################

getCVProb <- function(caret.model, class.name) {
  df <- caret.model$pred
  best <- caret.model$bestTune
  ids <- apply(df[, names(best), drop = FALSE], 1, function(r) all(r == best[1, ]))
  df <- df[ids, ]
  df <- df[order(df$rowIndex), c(class.name)]
  return(df)
}

getAllCV <- function(caret.model) {
  df <- caret.model$pred
  best <- caret.model$bestTune
  ids <- apply(df[ ,names(best), drop=FALSE], 1, function(r) all(r == best[1,]) )
  df <- df[ids, ]
  return(df)
}

