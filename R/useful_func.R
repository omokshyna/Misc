#-------------------------------------------------------------------------------
# Name:        	useful_func
# Purpose:     	Several useful functions for error checking
#
# Author:    	Olena Mokshyna
#
# Created:     	14.06.2013
#-------------------------------------------------------------------------------
#

#1
setdiff(x1, x2)

#2
#Check diff between 2 dataframes
fun.12 <- function(x.1,x.2,...){
     x.1p <- do.call("paste", x.1)
     x.2p <- do.call("paste", x.2)
     x.1[ x.1p %in% x.2p, ]
 }

#Deal with names containing special symbols
Quotemeta <- function(x) gsub("([^A-Za-z_0-9])", "\\\\\\1", x)