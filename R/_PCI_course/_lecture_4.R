y1 <- local(get(load("C:/Users/MEG/Documents/R_study/_PCI/data/sol_y1.RData")))

set.seed(42)
train.ids <- createDataPartition(y1, p = 0.4, times = 1)

train.ids <- train.ids[[1]]

x1 <- local(get(load("C:/Users/MEG/Documents/R_study/_PCI/data/sol_x1.RData")))

x1.train <- x1[train.ids, ]
x1.test <- x1[-train.ids, ]

y1.train <- y1[train.ids ]
y1.test <- y1[-train.ids ]

#Willet
require(proxy)
x1.scaled <- scale(x1)

set.seed(24)
startSet <- sample(1:nrow(x1.scaled), 5)
x1.test.diss <- x1.scaled[startSet, ]
x1.train.diss <- x1.scaled[-startSet, ]

newSamples <- maxDissim(x1.test.diss, x1.train.diss, n = 155, randomFrac = 0.1)

x1.test.diss <- rbind(x1.test.diss, x1.train.diss[newSamples,])
x1.train.diss <- x1.train.diss[-newSamples,]

#Use Manhattan distance
newSamples_Manhattan <- maxDissim(x1.test.diss, x1.train.diss, n = 20, 
                                  method="Manhattan", randomFrac = 0.1)

##################################Level 0

#near zero variables exclusion
nzv <- nearZeroVar(x1.train, freqCut=0, uniqueCut=0)

x1.train <- x1.train[, -nzv]

#correlations
# highCor <- findCorrelation(cor(x1.train), cutoff=0.9)
# 
# #Linear combinations
# linCombo <- findLinearCombos(x1.train)

#Preprocessing of data
preProc <- preProcess(x1.train, method=c("center", "scale"))

x1.train.scale <- predict(preProc, x1.train)


#Build model
trControl1 <- trainControl(method = "repeatedcv", 
                           number = 5, 
                           repeats = 2,
                           preProcOptions = NULL,
                           savePredictions = TRUE)

m1.pls <- train(x1.train.scale, 
                y1[train.ids],
                method = 'pls',
                trControl = trControl1)

#Load test set using preprocessing
#order descriptors as in train set, exclude absent in train, add absent in test
x1.test <- x1.test[, names(preProc$mean)] #use preProc because size is smaller than x1.train
x1.test <- predict(preProc, x1.test)

#Predict test set
pred <- predict(m1.pls, x1.test)
Metrics::rmse(y1.test, pred)


##################################Level 1
set.seed(42)

cv <- createFolds(y1.train, k=5, returnTrain=TRUE)
cv2 <- createMultiFolds(y1.train, 5, 3)

plsGrid <- data.frame(ncomp=1:7)

trControl2 <- trainControl(method="LGOCV",
                           index=cv,
                           preProcOptions=NULL,
                           savePredictions = TRUE)

m2.pls <- train(x1.train, 
                y1.train,
                method = 'pls',
                trControl = trControl2,
                tuneGrid = plsGrid)
