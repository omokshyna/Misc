#################################################################################################
#       						              					VIR_COEFF
#          												Script for data preprocessing 
#################################################################################################

#################################################################################################
#
#																					Create data files
#################################################################################################

workdir <- "D:\\GoogleDrive\\Calc\\VIR_COEFF\\Pure_sirms\\desc_pure\\" 
# workdir <- "D:/GoogleDrive/Calc/VIR_COEFF/_descr_all/pure/" 

#Load data for temperatures and virial coefficients
kIn1 <- read.table(paste(workdir, "temp_pure.csv", sep =""), header=TRUE, sep = ';', row.names=1, strip.white=TRUE)

#for coeff data
kIn1 <- read.table(paste(workdir, "coeff_exp.csv", sep =""), header=TRUE, sep = ',', row.names=1, strip.white=TRUE)

#Check for NA
which(is.na(kIn1))

#Load descriptors data
kIn2 <- read.table(paste(workdir, "all_transp.csv", sep = ""), header=TRUE, sep = ',',  row.names=1, strip.white = TRUE)
#Check for NA
which(is.na(kIn2))


# Split names of the molecules into two parts, eliminating the numbering
rownames(kIn2) <- sapply(strsplit(rownames(kIn2),'_'), "[[", 2)

#Substite bad names
rownames(kIn2) [which(rownames(kIn2) == "Methyl pentyl")] <- "Methyl pentyl ether"

#Check for NA
which(is.na(kIn2))

# Create list of names for search
names <- sapply(strsplit(rownames(kIn1),'_'), "[[", 2)
# for coeff
names <- rownames(kIn1)

#create output
kOut <- cbind(kIn1.new, kIn2.new[names, ])

#Check for NA
which(is.na(kOut), arr.ind=T)

#Write output to file
write.table(x=kOut, file = paste(workdir,"result_exp.csv", sep =""), sep=";")


#################################################################################################
#
#  										Calculate coefficients
#################################################################################################
names2 <- rownames(kIn2.new)

names_kIn1 <- sapply(strsplit(rownames(kIn1.new),'_'), "[[", 2)
kIn1 <- cbind(names_kIn1, kIn1.new)

coeff_list <- list(names = c("a", "b"))
cor <- list()


for (i in 1:length(names2)) {
  lmdata <- kIn1[kIn1$names_kIn1==names2[i],]
  if (dim(lmdata)[1] > 3) {
    y <- lmdata$B.cm3.mol.1
#     x <- -log(1/lmdata$T.K.)
    x <- exp(1/lmdata$T.K.)
    mod <- lm(y~ x)
    coeff_list$a <- c(coeff_list$a, mod$coefficients[["x"]]) 
    coeff_list$b <- c(coeff_list$b, mod$coefficients[["(Intercept)"]])
    cor <- c(cor, cor(y, mod$fitted.values))
  }  else  {
    coeff_list$a <- c(coeff_list$a, NA)
    coeff_list$b <- c(coeff_list$b, NA) 
  }
}

#Another check
which(cor < 0.9)

kOut.coeff <- as.data.frame(cbind(coeff_list$a, coeff_list$b), row.names = names2)
names(kOut.coeff) <- c('a', 'b')

kOut.coeff <- na.exclude(kOut.coeff)

#Write output to file
write.table(x=kOut.coeff, file = paste(workdir,"coeff_exp.csv", sep =""), sep=",")
#################################################################################################
#
#    																	Recalculate data using coefficients
#################################################################################################

#load calculated coefficients
#exponential
a.exp <- read.csv(paste(workdir, "rf_predicted_a_exp.csv", sep = ""), sep = ";", row.names = 1, header = T)
b.exp <- read.csv(paste(workdir, "rf_predicted_b_exp.csv", sep = ""), sep = ";", row.names = 1, header = T)
coef <- cbind(a.exp, b.exp)
coef <- read.csv(paste(workdir, "coeff_exp.csv", sep = ""), sep = ",", row.names = 1, header = T)
colnames(coef) <- c('a', 'b')

#linear
a.lin <- read.csv(paste(workdir, "rf_predicted_a.csv", sep = ""), sep = ";", row.names = 1, header = T)
b.lin <- read.csv(paste(workdir, "rf_predicted_b.csv", sep = ""), sep = ";", row.names = 1, header = T)
coef <- cbind(a.lin, b.lin)
colnames(coef) <- c('a', 'b')

#load experimental data
edata <- read.table(paste(workdir, "temp_pure.csv", sep =""), header=TRUE, sep = ';', row.names=1, strip.white=TRUE)
enames1 <- sapply(strsplit(rownames(edata),'_'), "[[", 2)
edata <- cbind(edata, enames1)

enames2 <- enames1[enames1 %in% rownames(coef)]
enames2 <- enames2[-which(enames2 %in% c("Bromodifluoromethane", "Nitromethane", "Acetonitrile",
                      "Ethanoic acid", "2,2,4,4,5,5-Hexafluoro-1,3-dioxolane",
                      "Propanal", "Butanenitrile", "1-Bromo-2-methylpropane",
                      "1-Bromobutane", "3-Methyl-1-butanol", "Methyl 3-methylbutyl ether",
                      "Benzoic acid", "3,4-Dimethylpyridine", "2-Methylnaphthalene"))]

#Final data
nd <- cbind(edata[edata$enames1 %in% enames2,], coef[enames2,])

#Recalculate
B.exp <- (nd$b/10 + nd$a*exp(1/nd$T.K.))/1000
B.exp <- nd$b + nd$a*exp(1/nd$T.K.)

R2 <- cor(B.exp,nd$B.cm3.mol.1.)^2
rmse <- RMSE(B.exp,nd$B.cm3.mol.1.)
rms <- sqrt(sum((B.exp - nd$B.cm3.mol.1.)^2/-nd$B.cm3.mol.1.)/dim(nd)[2])

B.lin <- nd$b + nd$a* (1/nd$T.K.)

R2 <- cor(B.lin,nd$B.cm3.mol.1.)^2
rmse <- RMSE(B.lin,nd$B.cm3.mol.1.)
rms <- sqrt(sum((B.lin - nd$B.cm3.mol.1.)^2/abs(nd$B.cm3.mol.1.))/dim(nd)[1])

pred.lin <- as.data.frame(cbind(nd$T.K., nd$B.cm3.mol.1., B.lin))
rownames(pred.lin) <- rownames(nd)

pred.exp <- as.data.frame(cbind(nd$T.K., nd$B.cm3.mol.1., B.exp))
rownames(pred.exp) <- rownames(nd)

#Check out names with high  and low deviations
badPred <- unique(sapply(strsplit(rownames(pred.lin[which(pred.lin[,2] - pred.lin[,3] > 500, arr.ind=T),]),
                       "_"), "[[", 2 ))
goodPred <- unique(sapply(strsplit(rownames(pred.lin[which(pred.lin[,2] - pred.lin[,3] < 100, arr.ind=T),]),
                                  "_"), "[[", 2 ))

badPred <- unique(sapply(strsplit(rownames(pred.exp[which(pred.exp[,2] - pred.exp[,3] > 1000, arr.ind=T),]),
                                  "_"), "[[", 2 ))
goodPred <- unique(sapply(strsplit(rownames(pred.exp[which(pred.exp[,2] - pred.exp[,3] < 100, arr.ind=T),]),
                                   "_"), "[[", 2 ))

#Save predictions
write.table(pred.exp, file = paste(workdir, model.type, "_pred_exp.csv", sep = ''), sep = ";")

