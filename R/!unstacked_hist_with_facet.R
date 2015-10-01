#-------------------------------------------------------------------------------
# Name:        	unstacked_hist_with_facet
# Purpose:     	Plot ROC curve/-s
#
# Author:    	Olena Mokshyna
#
# Created:     	28.01.2015
#-------------------------------------------------------------------------------
#



rsq <- data.frame("Validation" = c("Compounds-Out", "All-Mixtures-Out"), "Set" = c("ws", "ts"), 
                  "RF" = c(0.84, 0.76, 0.80, 0.70), 
                  "SVM" = c(0.75, 0.61, 0.72, 0.56), "PLS" = c(0.62, 0.57, 0.56, 0.51), 
                  "GLM" = c(0.54, 0.42, 0.50, 0.31))

rsq <- data.frame("Validation" = c("Compounds-Out", "All-Mixtures-Out"),  
                  "RF" = c(0.76, 0.70), 
                  "SVM" = c(0.61, 0.56), "PLS" = c(0.57, 0.51), 
                  "GLM" = c(0.42, 0.31))

require(reshape)
rsqm <- melt(rsq)
rsqm <- rsqm[order(rsqm$Set, decreasing=T),]

ggplot(rsqm, aes(y=value, x=variable,fill=variable)) + 
                                                geom_bar(stat="identity", barwidth = 20, position="dodge") +
                                                facet_wrap(~Validation, nrow=1) + 
                                                ylab(expression("R"^"2"))+theme_bw(base_size=32) +
                                                xlab("") +
                                                theme(legend.position = "none")
