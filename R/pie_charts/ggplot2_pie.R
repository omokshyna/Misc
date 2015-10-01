library(ggplot2)
library(sqldf)


workdir <- "C:/Users/Елена/Documents/pie_charts/"
df = read.csv(paste(workdir, 'data.csv', sep =''))

p = ggplot(data=df, 
           aes(x=factor(1),
               y=Summary,
               fill = factor(response)
           ),
) 

p=p + geom_bar(width = 1, stat = 'identity')

p=p+facet_grid(facets=. ~ gender)

p = p + coord_polar(theta="y") 
p

p = p + xlab('') +
  ylab('') +
  labs(fill='Response') 