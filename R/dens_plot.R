#-------------------------------------------------------------------------------
# Name:        	dens_plot
# Purpose:     	Build common density plot for several variables
#
# Author:      	Olena Mokshyna
#
# Created:     	16.10.2013
#-------------------------------------------------------------------------------
#


data_pc <- read.csv("D:\\!!QSAR\\CRIT_MIXT\\models\\data_pc.csv", row.names =1)
data_vc <- read.csv("D:\\!!QSAR\\CRIT_MIXT\\models\\data_vc.csv", row.names =1)
data_tc <- read.csv("D:\\!!QSAR\\CRIT_MIXT\\models\\data_tc.csv", row.names =1)


vc <- data.frame(data_vc[,1])
vc$Property <- 'Vc'

pc <- data.frame(data_pc[,1])
pc$Property <- 'Pc'

tc <- data.frame(data_tc[,1])
tc$Property <- 'Tc'

propLengths <- rbind(vc, tc)
propLengths <- rbind(propLengths, pc)

ggplot(propLengths, aes(propLengths$data_tc...1., fill = Property)) + geom_density(alpha = 0.2) + xlim(0,700) + scale_fill_discrete(breaks=c("Vc", "Tc", "Pc"), labels= c(expression('V'[c]), expression('T'[c]), expression('P'[c]))) + theme(text = element_text(size=20),legend.position = "bottom", legend.title=element_blank(), legend.text = element_text(size = 14)) + xlab(NULL) 

ggplot(tc, aes(tc$data_tc...1., fill = tc$Property)) + geom_histogram(alpha = 0.5) + xlim(180,750) + scale_fill_manual(name = expression('V'[c]), values = 'red') + theme(text = element_text(size=36),legend.position = "bottom", legend.title=element_blank(), legend.text = element_text(size = 40)) + xlab(NULL) 


scale_fill_discrete(breaks=c("Vc", "Tc", "Pc"), labels= c(expression('V'[c]), expression('T'[c]), expression('P'[c])))

ggplot(survival, aes(survival$data...1., fill = Property)) + geom_density(alpha = 0.2) + xlim(-0.5,1.5) +  scale_fill_discrete(labels= "Survival") + theme(text = element_text(size=20),legend.position = "bottom", legend.title=element_blank(), legend.text = element_text(size = 14), panel.background = element_rect(fill='white', colour='black')) + xlab(NULL) 


#bar plot builder for nano

#read csv
project.dir <- "D:\\!!QSAR\\CRIT_MIXT\\models\\vc\\"
imp <-  read.csv(paste(project.dir, "_imp.csv", sep =""), row.names = 1, sep=",", header = T)

summa <- apply(imp, 2,sum)
#imp <- rbind(imp, summa)
#rownames(imp)[[nrow(imp)]] <- "summa"

imp_calc <- apply(imp, 1, function(x) x/summa*100)
imp_calc_round1 <- apply(imp_calc, 1, ceiling)
vars1 <- as.factor(rownames(imp))

imp_calc_round2 <- apply(imp_calc, 1, ceiling)
vars2 <- as.factor(rownames(imp))
	
imp_calc_round3 <- apply(imp_calc, 1, ceiling)
vars3 <- as.factor(rownames(imp))
#Build plots for each  type of model
for (name in names(imp)) {
	#==============================First plot with named x-axis
	
		#Switch on png device to save plot
		png(filename = paste(project.dir,"imp1_", name, ".png", sep = ""))
	
		#Set margins
		par(mar=c(12,2,3,2), xpd=TRUE)
		#Build plot
		barplot(imp_calc_round[, name], ylab = "Relative variable importance", col = topo.colors(length(vars)), names.arg = c(rownames(imp_calc_round)), las = 2, main = name)
		#Switch off png device
		dev.off()

	#================================Second plot with legend
		png(filename = paste(project.dir,"imp2_", name, ".png", sep = ""))	
	
		#set free margin to create the place for the legend
		par(mar=c(3,2,3,14), xpd=TRUE)
	
		#Build plot
		barplot(imp_calc_round[ ,name], ylab = "Relative variable importance", col = rainbow(length(vars)), main = name, xlab = "Variables", names.arg = 1:length(rownames(imp)))
		
		#legend("bottomright", legend = rownames(imp), col=1:length(vars), cex = 0.8, pch=10, bty="o", pt.bg=1:length(vars))
		legend("right", inset=c(-0.45,0), legend = rownames(imp_calc_round), col = rainbow(length(vars)), cex = 1.1, pch=22, bty="n", pt.bg=rainbow(length(vars)),  text.width=2, x.intersp = 1)
		dev.off()
}
