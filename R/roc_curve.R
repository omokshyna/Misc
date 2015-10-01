#-------------------------------------------------------------------------------
# Name:        	roc_curve
# Purpose:     	Plot ROC curve/-s
#
# Author:    	Olena Mokshyna
#
# Created:     	28.01.2015
#-------------------------------------------------------------------------------
#

require(ROCR)
require(ggplot2)

#setwd("")

list.files()

data <- read.csv("_example_data/pred_consensus_inDA.csv")


pred <- data$meanPredSens #There is difference in classes
obs <- data$obs

df <- data.frame(obs=obs, pred=pred)

p <- performance(prediction(df$pred, df$obs), "tpr", "fpr")
roc <- data.frame(x=p@x.values[[1]], y=p@y.values[[1]])
ggplot(roc, aes(x=x, y=y)) + geom_path(size=0.5, color="blue") +
  xlab("1-Specificity") +
  ylab("Sensitivity") +
  theme(axis.text = element_text(size=10, colour="black"),
        panel.background = element_rect(fill="white"),
        panel.grid = element_line(colour="white"),
        panel.grid.minor = element_line(colour="white"),
        axis.line = element_line(size=0.8),
        axis.title.x = element_text(colour="black", size=12),
        axis.title.y = element_text(colour="black", size=12, angle=90))
ggsave("roc_consensus.png", height=8, width=10, units="cm")

##############################################################################################
#								SEVERAL CURVES
##############################################################################################

data1 <- read.csv("_example_data/pred_consensus.csv") #without DA
data2 <- read.csv("_example_data/pred_consensus_inDA.csv") #in DA

obs <- data1$obs

pred1 <- cbind(data1$meanPredStrong+data1$meanPredWeak+data1$meanPredMod, 
               data2$meanPredStrong+data2$meanPredWeak+data2$meanPredMod)
pred2 <- cbind(data1$meanPredWeak, data2$meanPredWeak)
pred3 <- cbind(data1$meanPredStrong+data1$meanPredWeak+data1$meanPredNon, 
              data2$meanPredStrong+data2$meanPredWeak+data2$meanPredNon)
pred4 <- cbind(data1$meanPredStrong, data2$meanPredStrong)

pred <- pred1
# pred <- data[,c("Sensitiser.gbm", "Sensitiser.rf", "Sensitiser.svm", "meanPredSens")]
df <- data.frame(cbind.data.frame(obs = obs, pred = pred))
# colnames(df)[2:ncol(df)] <- paste0("sd=", sd_seq)
levels(df$obs) <- c("Moderate", "Other", "Other", "Other")

# df <- melt(df, 1)
rocs <- lapply(2:ncol(df), function(i) {
  p <- performance(prediction(df[,i], df[,1]), "tpr", "fpr")
  data.frame(name=rep(colnames(df)[i], length(p@x.values[[1]])), x=p@x.values[[1]], y=p@y.values[[1]])
})

aucs <- sapply(2:ncol(df), function(i) {
  performance(prediction(df[,i], df[,1]), "auc")@y.values[[1]]
})
aucs <- round(aucs, 2)

rocs <- do.call(rbind, rocs)

g1 <- ggplot(rocs, aes(x=x, y=y)) + geom_path(aes(color=name), size=1) +
  xlab("1-Specificity") +
  ylab("Sensitivity") +
  theme(axis.text = element_text(size=14, colour="black"),
        panel.background = element_rect(fill="white"),
        panel.grid = element_line(colour="white"),
        panel.grid.minor = element_line(colour="white"),
        axis.line = element_line(size=0.8),
        axis.title.x = element_text(colour="black", size=16),
        axis.title.y = element_text(colour="black", size=16, angle=90),
        legend.position = "none",
        plot.title = element_text(size = 18, face="bold")) +
  scale_color_discrete(name = "Models", labels=c("Consensus", "Consensus in DA")) +
  ggtitle("Non-vs-All")

g <- grid_arrange_shared_legend(g1, g2, g3, g4))

ggsave("rocs.png", g, height=16, width=20, units="cm")

grid_arrange_shared_legend <- function(...) {
  plots <- list(...)
  g <- ggplotGrob(plots[[1]] + theme(legend.position="bottom"))$grobs
  legend <- g[[which(sapply(g, function(x) x$name) == "guide-box")]]
  lheight <- sum(legend$height)
  arrangeGrob( #in original function here is grid.arrange
    do.call(arrangeGrob, lapply(plots, function(x)
      x + theme(legend.position="none"))),
    legend,
    ncol = 1,
    heights = unit.c(unit(1, "npc") - lheight, lheight)
)
}