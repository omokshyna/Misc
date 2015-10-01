#interactive plot with plane 
library(Rcmdr)
mdata <- attach(mtcars)
scatter3d(wt, disp, mpg)
fit$loadings <- cbind(fit$loadings, sapply(strsplit(rownames(fit$loadings), '\\.'), '[[', 2))
scatter3d(as.numeric(fit$loadings[,1]), as.numeric(fit$loadings[,2]), as.numeric(fit$loadings[,3]),
          point.col = as.numeric(as.factor(fit$loadings[,4])))
rgl.snapshot('interactive.png',top=T)

# Spinning 3d Scatterplot
library(rgl)

plot3d(wt, disp, mpg, col="red", size=3)
plot3d(fit$loadings[,1:3], col = as.numeric(as.factor(fit$loadings[,4])), size = 3, type = 's')
rgl.snapshot('interactive.png')

#using scatterplot3d
library(scatterplot3d)
with(mtcars, {
  scatterplot3d(disp, angle=60,  # x axis
                wt,     # y axis
                mpg,    # z axis
                main="3-D Scatterplot Example 1")
})
=============================================================================================================
