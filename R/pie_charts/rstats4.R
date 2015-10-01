workdir <- "C:/Users/Елена/Documents/pie_charts/"
mydata100 = read.csv(paste(workdir, 'mydata100.csv', sep =''), row.names = 1)


#pie chart
ggplot( mydata100, aes(x = factor(""), fill = workshop)) + geom_bar()


ggplot(mydata100, aes(x = factor(''), fill = workshop)) + geom_bar() + coord_polar(theta="y") + 
  scale_x_discrete("")

#bar plot
ggplot(mydata100) + geom_bar(aes(workshop))


ggplot(mydata100, aes(workshop, fill = workshop) ) +
    geom_bar() + coord_flip()

ggplot(mydata100, aes(gender, fill = workshop) ) +
  geom_bar(position = 'stack') 

ggplot(mydata100, aes(gender, fill = workshop) ) +
  geom_bar(position = 'fill') 

ggplot(mydata100, aes(gender, fill = workshop) ) +
  geom_bar(position = 'dodge') 

ggplot(mydata100, aes(gender, fill = workshop) ) +
  geom_bar(position = 'dodge') + scale_fill_grey(start=0,end =1)

ggplot(mydata100, aes(gender, fill = workshop) ) +
  geom_bar(position = 'dodge') + scale_fill_grey(start=0,end =1) + facet_grid(gender~.)

