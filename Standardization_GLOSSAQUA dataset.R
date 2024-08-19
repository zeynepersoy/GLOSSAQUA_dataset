###########################################################
#                                                         #
#               Size spectrum transformation              #
#                                                         #
###########################################################

## Set the working directory
rm(list=ls(all=TRUE))
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Load the data
Sample <- read.table('data/GLOSSAQUA_Sample.txt', header = TRUE)
Size <- read.table('data/GLOSSAQUA_Size.txt', header = TRUE)


#### Size spectrum methods 
## Merge "Size" and "Sample" datasets together (BUT DO NOT remove duplicates)
## Transform "SizeSpectrumMethod" variable into a factor
## Rename the levels of "SizeSpectrumMethod"
Size_Sample <- full_join(Sample, Size, by = c("SourceID", "SiteID")) %>%
  mutate(SizeSpectrumMethod = as.factor(SizeSpectrumMethod)) %>% 
  mutate(SizeSpectrumMethod  = factor(SizeSpectrumMethod, labels = c("ASS", "BSS", "MLE", "NASS", "NBSS", "Pareto")))

#Loop to transform the theoretical values of the size spectrum slopes: Theoretical lambda = -2 (Sprules and Barth 2015; Guiet et al. 2016)
Size_Sample<- Size_Sample
# Add a new column called "Slope_mod" to store the modified slope values
Size_Sample$Slope_mod <- NA
length <- dim(DATA)[1]
count <- 1
for (i in 1:length){
  site <- Size_Sample[count,]
  if(site$SizeSpectrumMethod == "Normalized abundance spectrum (linear)"){ # value is lambda
    Size_Sample$Slope_mod[count] <-  as.numeric(site$Slope) 
  } else if (site$SizeSpectrumMethod == "Normalized biomass spectrum (linear)"){ # value is lambda + 1
    Size_Sample$Slope_mod[count] <- as.numeric(site$Slope) + 1
  } else if (site$SizeSpectrumMethod == "Abundance spectrum (linear)"){ # value is lambda + 1
    Size_Sample$Slope_mod[count] <- as.numeric(site$Slope) + 1
  } else if (site$SizeSpectrumMethod == "Biomass spectrum (linear)"){ # value is lambda + 2
    Size_Sample$Slope_mod[count] <- as.numeric(site$Slope) + 2
  } else if (site$SizeSpectrumMethod == "Maximum Likelihood"){ # value is lambda (Edwards et al. 2016)
    Size_Sample$Slope_mod[count] <- as.numeric(site$Slope) 
  } else {      #Type I Pareto probability density function (power) #value is lambda
    Size_Sample$Slope_mod[count] <- as.numeric(site$Slope)
  } 
  count <- count + 1
  print(i)
}
