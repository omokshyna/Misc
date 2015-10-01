###############################################################################################
#
#          										Model Building&Evaluation
#																(B = f(T, descriptors))
#
##############################################################################################
          
#MAIN FUNCTIONS

#Function that loads .csv files with data according to sets
LoadWs <- function(path, ws_pattern = "split_[0-9]_ws_[0-9]", ts_pattern = "split_[0-9]_ts_[0-9]") {
  wsFiles <- list.files(workdir, ws_pattern)
  tsFiles <- list.files(workdir, ts_pattern)
  #setList <- list()
  wsList <- list()
	tsList <- list()
	setList <- list()
	
  # list of lists (1: data_frame_ws; 2: df_ts)
	
  for (i in 1:length(wsFiles)) {
  	wsList[[i]] <- read.table(paste(workdir, wsFiles[[i]], sep = ""), sep = ',', row.names=1, header = TRUE)
  	tsList[[i]] <- read.table(paste(workdir, tsFiles[[i]], sep = ""), sep = ',',row.names=1, header = TRUE)
  	setList[[i]] <- list("ws" = wsList[[i]], "ts"=tsList[[i]])
  }
	return (setList)
}

#Data preprocessing 
DataPrep <- function(data, nzv = TRUE) {
	#Load caret library
	library(caret)
	
	#Check for NA in data
	for (element in is.na(data)) {
		if (element  == TRUE) {
			print("Data contains NA! Check the data!")
			break 
		}
	}
	
	#delete nzv
	if (nzv == TRUE) {
		nzv <- nearZeroVar(data)
		data <- data[, - nzv]
	}
	return (data)
}	


#Assign working directory
workdir <- "C:\\Users\\?????\\???? Google\\Calc\\VIR_COEFF\\Pure_sirms\\desc_pure\\"

#Choose type of model
  #model.type = "GLM" 
  #model.type = "PLS"
	#model.type = "RF" 
  model.type = "SVM"
	
#assign directory to save the models
model.dir <- paste(workdir, "Models\\", model.type, "\\", sep="")


setLst <- LoadWs(workdir, ws_pattern = "split_[0-9]_ws_[0-9]", ts_pattern = "split_[0-9]_ts_[0-9]")
nameLst <- sapply(strsplit(list.files(workdir, pattern="split_[0-9]_ws"), split="\\."), "[[", 1)

parameters <- NULL
for (i in 1:length(setLst)) { 
	ws <- setLst[[i]]$ws
	ts <- setLst[[i]]$ts
	ws <- DataPrep(ws)
  colnames(ws)[1] <- colnames(ts)[1]
	ts <- ts[ ,colnames(ts) %in% colnames(ws)]
  # Don't exclude cross-cor for ts!!!
	scalingValues <- preProcess(ws[,2:ncol(ws)], method = "scale") #only scaling #only on descriptors CHANGE!!!
	ws[,2:ncol(ws)] <- predict(scalingValues, ws[,2:ncol(ws)])
	ts[,2:ncol(ts)] <- predict(scalingValues, ts[,2:ncol(ts)])
		
	#Call model building function
	model.name <- paste(model.type,"_", nameLst[[i]], sep = "")
	parameters <- rbind(parameters, as.data.frame(switch(model.type,
	       glm = BuildGLMModels(ws, ts, model.name, model.dir, model.type),
	       pls = BuildPLSModels(ws, ts, model.name, model.dir, model.type),
	       rf = BuildRFModels(ws, ts, model.name, model.dir, model.type),
         svm = BuildSVMModels(ws, ts, model.name, model.dir, model.type),
	       #nnet = BuildNNETModels(ws, ts, model.name, model.dir, model.type)
                                                       )
        ))
}	

#Write summary table for given model.type
parameters <- as.data.frame(rbind(parameters, apply(parameters, 2, mean)))
rownames(parameters) <- c(seq(1,nrow(parameters) - 1), 'mean')
write.table(parameters, paste(model.dir, "parameters_", model.type, ".csv", sep =""), sep = ",")

#Make summary plots for all sets
#load predicted for all test sets, rbind them




