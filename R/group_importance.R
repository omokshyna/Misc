#-------------------------------------------------------------------------------
# Name:        	group_importance
# Purpose:     	Calculate variable importance using permutation
#				for group of variables
#
# Authors:    	Pavel Polishchuk
#				Olena Mokshyna
#
# Created:     	13.10.2013
#-------------------------------------------------------------------------------
#


library(randomForest)

mse <- function(obs, pred) sum((obs-pred)^2)/length(obs)

set.seed(100)
df <- na.omit(airquality)
rf <- randomForest(Ozone ~ ., data = airquality, ntree = 500, 
                         na.action = na.omit, nrep = 100, importance = T, 
                         replace = T, keep.inbag = T)
oob.names <- apply(rf$inbag, 2, function(x) rownames(df)[x==0])

pred <- predict(rf, df, predict.all=TRUE)[[2]]
mse.oob <- sapply(seq_along(oob.names), function(i) {
  mse(df[oob.names[[i]], "Ozone"], pred[oob.names[[i]], i])
})


names <- c('Wind', 'Month')

df.perm <- df
for (name in names) {
  df.perm[,name] <- sample(df[,name])
}

pred.perm <- predict(rf, df.perm, predict.all=TRUE)[[2]]

mse.oob.perm <- sapply(seq_along(oob.names), function(i) {
  mse(df[oob.names[[i]], "Ozone"], pred.perm[oob.names[[i]], i])
})

imp <- mean(mse.oob.perm - mse.oob)


rf_imp <- function(rf.model, df, y.name, x.names, ntimes=1, seed=NULL) {
  oob.names <- apply(rf.model$inbag, 2, function(x) rownames(df)[x==0])

  pred <- predict(rf.model, df, predict.all=TRUE)[[2]]
  mse.oob <- sapply(seq_along(oob.names), function(i) {
    mse(df[oob.names[[i]], y.name], pred[oob.names[[i]], i])
  })
  
  if (!is.null(seed)) set.seed(seed)
  
  imp <- sapply(1:ntimes, function(n) {
  
    df.perm <- df
    for (name in x.names) {
      df.perm[,name] <- sample(df[,name])
    }
    
    pred.perm <- predict(rf.model, df.perm, predict.all=TRUE)[[2]]
    
    mse.oob.perm <- sapply(seq_along(oob.names), function(i) {
      mse(df[oob.names[[i]], y.name], pred.perm[oob.names[[i]], i])
    })
    
    mean(mse.oob.perm - mse.oob)
  })
  
  return(imp)
}

tmp <- rf_imp(rf, df, "Ozone", c("Wind", "Day"), 50, NULL)
tmp <- rf_imp(rf, df, "Ozone", c("Wind", "Temp"), 50, NULL)
tmp <- rf_imp(rf, df, "Ozone", c("Month", "Day"), 50, NULL)
summary(tmp)