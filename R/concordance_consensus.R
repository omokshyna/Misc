#-------------------------------------------------------------------------------
# Name:        	concordance_consensus
# Purpose:     	Calculate applicability domain using concordance values
# Description: 	Compound is considered to be out of applicability domain 
#				if and only if it is predicted to be in the wrong class and 
#				difference between the probabilities of being in right and wrong 
#				classes is bigger than some threshold value (in this study value 
#				of 0.3 was used). For multiclass classification the biggest 
#				probability value is found and compared with that of the right class.
#				For the consensus model probabilities are averaged
#
# Author:      Olena Mokshyna
#
# Created:     10.03.2015
#-------------------------------------------------------------------------------

#

setwd("_example_data/concordanceDA")
options(stringsAsFactors = FALSE)

threshold <- 0.3

#Load files with predictions
fl <- list.files(pattern =  "_fold")
data <- NULL

for (name in fl) {
  f <- read.csv(name, sep=',')
  data[[name]] <- data.frame(f$pred, f$obs, f$Non, f$Sensitiser, f$rowIndex, f$Resample, f$pred.names)
  colnames(data[[name]]) <- c('pred', 'obs', 'Non', 'Sensitiser', 'rowIndex', 'Resample', 'pred.names')
  data[[name]]$OutOfDA <- (data[[name]][,1] != data[[name]][,2]) & 
    (abs(data[[name]]$Non - data[[name]]$Sensitiser) > threshold) 
}

 
#use melt and reshape
require(reshape2)

#Merge into one
v <- do.call(rbind, data)
v <- cbind(v, sapply(strsplit(rownames(v),'_'), "[[", 1))
colnames(v)[dim(v)[2]] <- "model"
rownames(v) <- NULL

vn <- melt(v, id.vars = c("pred.names", "pred", "obs", 
                          "Non", "Sensitiser", "model", "rowIndex", "Resample", "OutOfDA"))
# View(vn)
vnr <- reshape(vn, direction = "wide", timevar = 'model', idvar = c('pred.names', 'obs', 'rowIndex', 'Resample')) 
# View(vnr)

#sort by indices
vnr <- vnr[order(vnr$rowIndex), ]
rownames(vnr) <- NULL
# View(vnr)


#Calculate mean of probability (with all compounds)
vnr$meanPredNon <- rowMeans(cbind(vnr$Non.gbm, vnr$Non.rf, vnr$Non.svm))
# View(vnr)

vnr$meanPredSens <- rowMeans(cbind(vnr$Sensitiser.gbm, vnr$Sensitiser.rf, vnr$Sensitiser.svm))
# View(vnr)

vnr$meanPred <- ifelse(vnr$meanPredNon > vnr$meanPredSens, "Non", "Sensitiser")

#Calculate mean of probability (with only compounds in DA)
#substitute with NA those who outside of DA
vnrInDA <- vnr

for (model in c('gbm', 'svm', 'rf')) {
  ids <- which(vnrInDA[,paste('OutOfDA.', model, sep = '')] == TRUE)
  vnrInDA[ids,paste('Sensitiser.', model, sep = '')] <- NA
  vnrInDA[ids,paste('Non.', model, sep = '')] <- NA


# View(vnrInDA)

vnrInDA$meanPredNon <- NULL
vnrInDA$meanPredNon <- rowMeans(cbind(vnrInDA$Non.gbm, vnrInDA$Non.rf, vnrInDA$Non.svm), 
                                na.rm = TRUE)
# View(vnrInDA)

vnrInDA$meanPredSens <- NULL
vnrInDA$meanPredSens <- rowMeans(cbind(vnrInDA$Sensitiser.gbm, vnrInDA$Sensitiser.rf, vnrInDA$Sensitiser.svm), 
                                 na.rm = TRUE)
# View(vnrInDA)
vnrInDA$meanPred <- ifelse(vnrInDA$meanPredNon > vnr$meanPredSens, "Non", "Sensitiser")


#Calculate errors for consensus models
require(caret)
cm <- confusionMatrix(vnr$meanPred, vnr$obs)
res <- c(cm$overall, cm$byClass)
write.table(as.matrix(cm), file = "!consensus_cm.csv", sep = ",")
write.table(res, file = "!consensus_stat.csv", sep = ",")

cmInDA <- confusionMatrix(vnrInDA$meanPred, vnr$obs)
resInDA <- c(cmInDA$overall, cmInDA$byClass)
write.table(as.matrix(cmInDA), file = "!consensus_cm_inDA.csv", sep = ",")
write.table(resInDA, file = "!consensus_stat_inDA.csv", sep = ",")

#Save final predictions
write.table(vnr, "!pred_consensus.csv", sep = ',')
write.table(vnrInDA, "!pred_consensus_inDA.csv", sep = ',')

#calculate coverage
numNA <- length(which(is.na(vnrInDA$meanPred)))
numCompounds <- dim(f)[1]
coverage <- round((1 - numNA/numCompounds) * 100, 2)
covTab <- cbind(numNA, numCompounds, coverage)

write.table(covTab, "!coverage.csv", sep = ',', row.names = F)
