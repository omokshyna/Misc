#Function to read SiRMS data files
readDat <- function(fname) {
  cds <- gsub("dat", "cds", fname)
  
  cds.ready <- read.table(cds, sep = " ", header = F, fill = T, quote = "`") #, fileEncoding = "UTF-8")
  
  nrows_dat <- as.numeric(as.character(cds.ready[1, 1]))
  ncols_dat <- as.numeric(as.character(cds.ready[1, 2]))
  
  dat.ready <- readBin(fname, double(), nrows_dat*ncols_dat, size = 4)
  #   dat.matrix <- matrix(dat.ready, nrow=nrows_dat, ncol=ncols_dat)
  dat.matrix <- matrix(dat.ready, nrow=ncols_dat, ncol=nrows_dat, byrow = T)
  
  var.names <- as.character(cds.ready[2:(nrows_dat+1), 3])
  mol.names <- as.character(cds.ready[(nrows_dat+2):nrow(cds.ready), 2])
  
  #delete blank lines from column names
  if ("" %in% mol.names) {
    mol.names <- mol.names[-which(mol.names=="")]}
  
  dat.final <- data.frame(dat.matrix, row.names =  mol.names)
  #   dat.final <- data.frame(t(dat.frame), row.names =  mol.names)
  colnames(dat.final) <- var.names
  
  return(dat.final)
}