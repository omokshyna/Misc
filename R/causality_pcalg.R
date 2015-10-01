#-------------------------------------------------------------------------------
# Name:        causality_pcalg
# Purpose:     Causal inference using pcalg algorithm
#
# Author:      Olena Mokshyna
#
# Created:     13.01.2014
#-------------------------------------------------------------------------------

#load data 
data <- read.csv('_example_data/DM_Immobilization_SAD.csv',
                 row.names = 1, header = T)

#load libraries
library(pcalg)
library(caret)

#Preprepare data
descr <- data[,2:ncol(data)]
#scale&center descr
descr <- as.data.frame(scale(descr))
#create new dataframe with scaled descriptors
data <- cbind(data[,1], descr)

#use pc model
#calculate stat
suffStat <- list(C = cor(data), n = nrow(data))
pc.fit <- pc(suffStat, indepTest = gaussCItest,
             p = ncol(data), alpha = 0.15)
stopifnot(require(Rgraphviz))# needed for all our graph plots
plot(pc.fit, main = "")

#use fci
fci.fit <- fci(suffStat, indepTest = gaussCItest,
            p = ncol(data), alpha = 0.1)
plot(fci.fit)


