setwd("C:/Users/MEG/Documents/R_study/_PCI/")

cv <- read.table("models_predictions/cv_pred.txt", sep="\t", header=TRUE, as.is=TRUE)
test <- read.table("models_predictions/test_pred.txt", sep="\t", header=TRUE, as.is=TRUE)

cv <- round(cv, 2)
test <- round(test, 2)

y <- local(get(load("data/sol_y1.RData")))
y.test <- local(get(load("data/sol_y2.RData")))
cv$obs <- y
test$obs <- y.test

cv$set <- "cv"
test$set <- "test"

df <- rbind(cv, test)

require(ggplot2)

#single model plot
g1 <- ggplot(df, aes(x = obs, y = m.gbm)) + geom_point()
g1

g2 <- ggplot(df, aes(x = obs, y = m.gbm, color = set)) + geom_point()
g2

g3 <- ggplot(df, aes(x = obs, y = m.gbm, color = set, shape = set)) + geom_point()
g3

g4 <- ggplot(df, aes(x = obs, y = m.gbm, color = set, shape = set)) + geom_point(size = 4)
g4

g5 <- ggplot(df, aes(x = obs, y = m.gbm, color = set, shape = set)) + geom_point(size = 4, alpha = .8)
g5

g6 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
#   geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y))
  geom_abline(intercept = 0, slope = 1)
g6

g7 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5)
g7

g8 <- g7 + stat_smooth(method = "lm", aes(colour=set))
g8

g10 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_abline(intercept = 0, slope = 1) +
  geom_point(aes(color=set, shape=set), size=4, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se= FALSE)
g10

g11 <- g10 + scale_color_grey()
g11

g12 <- g10 + scale_color_manual(values = c("red", "blue"))
g12

g12.1 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=4, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_color_manual(values=c("#FF22FF", "#2255FF"))
g12.1

g12.2 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_x_reverse()
g12.2

g12.3 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_x_reverse() +
  scale_y_reverse()
g12.3

g12.4 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_color_manual(values=c("red", "blue")) +
  coord_flip()
g12.4

# use theme to control graphic output
# there are several predifined themes, but you may create your own
# to descrease amount of code to copy-paste return to the LEGO mode
g13 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_color_manual(values=c("red", "blue"))
g13

g13.1 <- g13 + theme_bw()
g13.1

g13.2 <- g13 + theme_classic()
g13.2

g13.3 <- g13 + theme_minimal()
g13.3

# change x labels
g13.4 <- g13 +
  theme_minimal() +
  theme(axis.text.x = element_text(color="red", size=15, angle=45, hjust=1))
g13.4

# change plot area background
# remove all grid lines
g13.6 <- g13 +
  theme(axis.text.x = element_text(color="red", size=15, angle=45, hjust=1),
        panel.background = element_rect(colour = "blue", fill="lightgreen"),
        panel.grid = element_blank())
g13.6

# facet
g14 <- ggplot(df, aes(x=obs, y=m.gbm)) + 
  geom_line(data=data.frame(x=c(-12,2), y=c(-12,2)), aes(x=x, y=y)) +
  geom_point(aes(color=set, shape=set), size=3, alpha=0.5) +
  stat_smooth(method="lm", aes(group=set, color=set), fullrange=TRUE, se=FALSE) +
  scale_color_manual(values=c("red", "blue")) +
  facet_wrap(~set)
g14

# look at distribution of training and test sets data
g15 <- ggplot(df, aes(x=obs)) +
  geom_histogram()
g15

g15.1 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1)
g15.1

g15.2 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1, aes(fill=set))
g15.2

g15.3 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1, aes(fill=set), color="black")
g15.3

g15.4 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1, aes(fill=set), color="white") +
  theme(legend.position = "none") +
  facet_wrap(~set)
g15.4

g15.5 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1, aes(fill=set), color="white") +
  theme(legend.position = "none") +
  facet_wrap(~set, ncol=1)
g15.5

g15.5 <- ggplot(df, aes(x=obs)) +
  geom_histogram(binwidth=1, aes(fill=set), color="white") +
  theme(legend.position = "none") +
  facet_wrap(~set, ncol=1, scales = "free_y")
g15.5

g15.7 <- ggplot(df, aes(x=obs)) +
  geom_density(aes(fill=set), color="white") +
  facet_wrap(~set, ncol=1)
g15.7

require(reshape)
df1 <- melt(df, id.vars=c("set","obs"))
dim(df1)

colnames(df1)[3:4] <- c("model", "pred")
head(df1)

# let's draw
g16 <- ggplot(df1, aes(x=obs, y=pred)) + 
  geom_point(aes(color=set)) +
  facet_wrap(~ model)
g16

g16.1 <- g16 + theme_classic()
g16.1

#calc prediction error
df1$mse <- (df1$obs - df1$pred) ^ 2

g17 <- ggplot(df1, aes(x=model, y = mse)) + 
  geom_bar(stat="summary", fun.y = "mean", aes(fill=set), position = "dodge")
g17

ggsave("data/plot.jpg", plot=g17 + theme_classic(), width=20, height=15, units="cm", dpi=600)

rmse <- function(x) {
  sqrt(mean(x))
}

g18 <- ggplot(df1, aes(x=model, y = mse)) + 
  geom_bar(stat="summary", fun.y = rmse, aes(fill=set), position = "dodge")
g18
