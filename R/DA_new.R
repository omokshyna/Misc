getRegStat2 <- function(model) {
  
  frag_control <- function(train_df, test_df) {
    train_names <- colnames(train_df)[!sapply(train_df, function(i) all(i == 0))]
    which(apply(test_df, 1, function(i) {
      n <- names(i)[i != 0]
      length(setdiff(n, train_names)) == 0
    }))
  }
  
  # add columns fold and rep for predicted data.frame
  df <- model$pred
  par_names <- colnames(model$bestTune)
  df <- cbind(df, do.call(rbind, strsplit(df$Resample, "\\.")))
  colnames(df)[(ncol(df) - 1) : ncol(df)] <- c("fold", "rep")
  
  # calc stat for each rep
  names <- apply(df[,c(par_names, "rep")], 1, paste0, collapse = "#")
  tmp <- split(df, names)
  res <- as.data.frame(t(sapply(tmp, function(tmp_df) {
    c("R2"=R2test(tmp_df$pred, tmp_df$obs), "RMSE"=rmse(tmp_df$obs, tmp_df$pred))
  })))
  
  # add column with parameters names to the result
  tmp <- as.data.frame(do.call(rbind, strsplit(rownames(res), "#")))
  tmp[, -ncol(tmp)] <- sapply(tmp[-ncol(tmp)], function(i) as.numeric(as.character(i)))
  res <- cbind(res, tmp)
  colnames(res)[(ncol(res) - length(par_names)):ncol(res)] <- c(par_names, "rep")
  
  # find ids in DA
  ids_da <- lapply(model$control$indexOut, function(case_ids) {
    ids <- frag_control(model$trainingData[-case_ids,], model$trainingData[case_ids,])
    case_ids[ids]
  })
  names(ids_da) <- names(model$control$index)
  
  # workaround - the issue with models with one repetition: names of folds are renamed to "Resample", not "Fold2.Rep1"
  if (length(unique(df$rep)) == 1) {
    ids_da <- list(Rep1 = unlist(ids_da))
  } else {
    ids_da <- split(ids_da, list(sub("^.*(Rep[0-9]*)$", "\\1", names(ids_da))))
    ids_da <- lapply(ids_da, unlist)
  }
  
  # calc stat with DA
  names <- apply(df[,c(par_names, "rep")], 1, paste0, collapse = "#")
  tmp <- split(df, names)
  res_da <- as.data.frame(t(sapply(tmp, function(tmp_df) {
    ids <- tmp_df$rowIndex %in% ids_da[[as.character(unique(tmp_df$rep))]]
    c("R2_DA" = R2test(tmp_df$pred[ids], tmp_df$obs[ids], mean(tmp_df$obs)), 
      "RMSE_DA" = rmse(tmp_df$obs[ids], tmp_df$pred[ids]),
      "DA_coverage" = sum(ids) / length(ids))
  })))
  
  # add column with parameters names to the result
  tmp <- as.data.frame(do.call(rbind, strsplit(rownames(res_da), "#")))
  tmp[, -ncol(tmp)] <- sapply(tmp[-ncol(tmp)], function(i) as.numeric(as.character(i)))
  res_da <- cbind(res_da, tmp)
  colnames(res_da)[(ncol(res_da) - length(par_names)):ncol(res_da)] <- c(par_names, "rep")
  
  output <- cbind(aggregate(res[,1:2], res[, par_names, drop = FALSE], mean), 
                  aggregate(res[,1:2], res[, par_names, drop = FALSE], sd)[, -(1:length(par_names))],
                  aggregate(res_da[,1:2], res_da[, par_names, drop = FALSE], mean)[, -(1:length(par_names))],
                  aggregate(res_da[,1:2], res_da[, par_names, drop = FALSE], sd)[, -(1:length(par_names))],
                  aggregate(res_da[,3], res_da[, par_names, drop = FALSE], mean)[, -(1:length(par_names))])
  
  colnames(output)[(length(par_names) + 1):ncol(output)] <- 
    c("R2", "RMSE", "R2_SD", "RMSE_SD", "R2_DA", "RMSE_DA", "R2_DA_SD", 
      "RMSE_DA_SD", "Coverage")
  
  output[, 1:length(par_names)] <- sapply(output[, 1:length(par_names)], function(i) as.numeric(as.character(i)))
  
  return(output)
}
