df <- data(iris)
str(iris)

library(caret)

###PLOTS

featurePlot(x=iris[,1:4], y = iris$Species, plot = "pairs", auto.key = list(columns=3))

featurePlot(x=iris[,1:4], y=iris$Species, "ellipse", auto.key = list(columns=3))

featurePlot(x=iris[,1:4], y=iris$Species, "density", scales = list(y = list(relation = "free"), x = list(relation = "free")), auto.key = list(columns=3), layout = c(4,1))

featurePlot(x=iris[,1:4], y=iris$Species, "box", scales = list(y = list(relation = "free"), x = list(rot = 90)), auto.key = list(columns=3), layout = c(4,1))

data(BloodBrain)

regVar <- c("tpsa", "mw", "clogp")
str(bbbDescr[ ,regVar])

featurePlot(x=bbbDescr[ , regVar], y = logBBB, plot = "scatter", type = c("p", "r"), span = .5, layout = c(3,1))


###DUMMY VARS
library(earth)
data(etitanic)

head(model.matrix(survived ~ ., data = etitanic))
dummies <- dummyVars(survived ~., data = etitanic)
head(predict(dummies, newdata = etitanic))

###NEAR-ZERO-VARIANCE
data(mdrr)
data.frame(table(mdrrDescr$nR11))

nzv <- nearZeroVar(mdrrDescr, saveMetrics=TRUE)
nzv[nzv$nzv,] [1:10, ]
dim(mdrrDescr)
nzv <- nearZeroVar(mdrrDescr)


filteredDescr <- mdrrDescr [, - nzv]
dim(filteredDescr)

###CORRELATED-DESCRIPTORS
descrCor <- cor(filteredDescr)
highCorr <- sum(abs(descrCor[upper.tri(descrCor)]) > 0.999)
descrCor <- cor(filteredDescr)
summary(descrCor[upper.tri(descrCor)])
highlyCorDescr <- findCorrelation(descrCor, cutoff = 0.75)
filteredDescr <- filteredDescr[, -highlyCorDescr]
dim(filteredDescr)
descrCor2 <- cor(filteredDescr)
summary(descrCor2[upper.tri(descrCor2)])

###LINEAR DEPENDENCIES
#Here is a place for linear dependencies
###

##CENTERING AND SCALING
set.seed(96)
inTrain <- sample(seq(along = mdrrClass), length(mdrrClass)/2)
training <- filteredDescr[inTrain, ]
test <- filteredDescr[-inTrain,]

trainMDRR <- mdrrClass[inTrain]
testMDRR <- mdrrClass[-inTrain]

preProcValues <- preProcess(training, method = c("center", "scale"))

###SPATIAL SIGN TRANSFORMATION
plotSubset <- data.frame(scale(mdrrDescr[, c("nC", "X4v")]))
xyplot(nC ~ X4v, data = plotSubset, groups = mdrrClass, auto.key = list(columns = 2))

xyplot(nC ~ X4v, data = spatialSign(plotSubset), groups = mdrrClass, auto.key = list(columns = 2))

###BoxCox TRANSFORMATION

preProcValues2 <- preProcess(training, method = "BoxCox")
trainBC <- predict(preProcValues2, training )
testBC <- predict(preProcValues2, test)
preProcValues2

##############

##CLASS DISTANCE CALCULATION
centroids <- classDist(trainBC, trainMDRR)
distances <- predict(centroids, testBC)
head(distances)

splom(distances, groups = testMDRR, plot = "pairs", auto.key = list(columns = 2))
#=================================================================

library(caret)
set.seed(3456)
trainIndex <- createDataPartition(iris$Species, p = .8, list = FALSE, times = 1)
#trainIndex <- createFolds(iris$Species, k=5)

irisTrain <- iris[trainIndex, ]
irisTest <- iris[-trainIndex, ]

#########Splitting based on predictors
library(caret)
library(mlbench)
data(BostonHousing)

testing <- scale(BostonHousing[,c("age", "nox")])

set.seed(11)
startSet <- sample(1:dim(testing) [1], 5)

samplePool <- testing[-startSet,]
start <- testing[startSet, ]
newSamp <- maxDissim (start, samplePool, n=20)
head(newSamp)

########################KNN
library(mlbench)
library(caret)

data(Sonar)

set.seed(808)

inTrain <- createDataPartition(Sonar$Class, p = 2/3, list = FALSE)

sonarTrain <- Sonar[inTrain, - ncol(Sonar)]
sonarTest <- Sonar[-inTrain, -ncol(Sonar)]

trainClass <- Sonar[inTrain, "Class"]
testClass <- Sonar[-inTrain, "Class"]

centerScale <- preProcess(sonarTrain)
head(centerScale)

training <- predict(centerScale, sonarTrain)
testing <- predict(centerScale, sonarTest)

knnFit <- knn3(training, trainClass, k=11)
knnFit

predict(knnFit, head(testing), type = "prob")

###PLS FOR DISCRIMINANT ANALYsIS

plsFit <- plsda(training, trainClass, ncomp = 20)

plsFit

plsBayesFit <- plsda(training, trainClass, ncomp = 20, probMethod="Bayes")

predict(plsFit, head(testing), type="prob")

predict(plsBayesFit, head(testing), type = "prob")

##AVERAGED NEURAL NETWORKS
set.seed(825)
avNetFit <- train(x=training, y = trainClass, method="avNNet", repeats = 5, trace = FALSE)
summary(avNetFit)
plot(avNetFit)

##AGGREGATE
set.seed(825)
baggedCT <- bag(x = training[, names(training) != "Class"], y = trainClass, B = 50, bagControl = bagControl(fit = ctreeBag$fit, predict = ctreeBag$pred, aggregate = ctreeBag$aggregate))
summary(baggedCT)

##########################################################################################################
#MODEL TRAINING & PARAMETER TUNING
##########################################################################################################
library(mlbench)
data(Sonar)

library(caret)

inTraining <- createDataPartition(Sonar$Class, times = 1, p = .75, list = FALSE)

training <- Sonar[inTraining, ]
testing <- Sonar[-inTraining, ]

fitControl <- trainControl(method = "repeatedcv", number = 10, repeats = 10)

set.seed(825)
gbmFit1 <- train(Class ~ ., data=training, method="gbm", trControl= fitControl, verbose = FALSE, summaryFunction=twoClassSummary)
gbmFit1

#Alternate tuning grids

gbmGrid <- expand.grid(.interaction.depth = c(1,5,9), .n.trees = (10:15)*100, .shrinkage = 0.1)
nrow(gbmGrid)

set.seed(825)
gbmFit2 <- train(Class ~., data = training, method = "gbm", trControl=fitControl, verbose = FALSE, tuneGrid=gbmGrid)
gbmFit2

plot(gbmFit2, metric = "Kappa")
plot(gbmFit2, metric = "Kappa", plotType = "level", scales = list(x=list(rot=90)))

fitControl <- trainControl(method = "repeatedcv", number = 3, repeats = 3, classProbs= TRUE, summaryFunction=twoClassSummary)

set.seed(825)

gbmFit3 <- train(Class ~., data = training, method = "gbm", trControl=fitControl, verbose = FALSE, tuneGrid = gbmGrid, metric = "ROC") 
gbmFit3

##Choosing the Final Model
whichTwoPct <- tolerance(gbmFit3$results, "ROC", 2, TRUE)
cat("Best model within 2 pct of best:\n")
gbmFit3$results[whichTwoPct, ]

predict(gbmFit3, head(testing))
predict(gbmFit3, head(testing), type = "prob")

densityplot(gbmFit3, pch = "|")

###Between-models

set.seed(825)
svmFit <- train(Class ~ ., data = training, method = "svmRadial", trControl = fitControl, preProc = c("center", "scale"), tuneLength = 8, metric = "ROC")

svmFit

set.seed(825)

rdaFit <- train(Class ~ ., data = training, method = "rda", trControl = fitControl,tuneLength = 4, metric = "ROC")
rdaFit

##CUSTOM METHODS FOR TRAIN
library(rpart)

cpValues10 <- rpart(Class ~., data = training, control = rpart.control(minsplit = 10))$cptable[,"CP"]
cpValues30 <- rpart(Class ~., data = training, control = rpart.control(minsplit = 30))$cptable[,"CP"]
head(cpValues30)

rpartGrid <- data.frame(.cp = c(cpValues10, cpValues30), .minsplit = c(rep(10, length(cpValues10)), rep(30, length(cpValues30))))

modelFunc <- function(data, parameters, levels, last, ...) {
  library(rpart)
  ctrl <- rpart.control(cp = parameters$.cp, misplit = parameters$.minsplit)
  list(fit = rpart(.outcome ~., data = data, control = ctrl))
}

predFunc <- function(object, newdata) {
  library(rpart)
  predict(object$fit, newdata, type = "class")
}

sortFunc <- function(x) x[order(x$cp, x$minsplit), ]

ctrl <- trainControl(custom= list(parameters = rpartGrid, model = modelFunc, prediction = predFunc, probability = NULL, sort = sortFunction), method = "repeatedcv", repeats = 10)

set.seed(581)

customRpart <- train(Class ~., data = training, method = "custom", trControl=ctrl)
rpartPlot <- plot(customRpart, scales = list(x = list(log = 10)))
rpartPlot
rpartPlot <- update(rpartPlot, xlab = "Compexity Parameter")
rpartPlot








