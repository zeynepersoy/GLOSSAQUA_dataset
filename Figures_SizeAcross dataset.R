
## Set the working directory
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

## Load packages
library(dplyr) 
library(maps)
library(scico)
library(ggplot2)
library(cowplot)
library(forcats)         
library(gghalves)         

## Load the data
Source <- read.table('data/SizeAcross_DataSource.txt')
Sample <- read.table('data/SizeAcross_Sample.txt')
Size <- read.table('data/SizeAcross_Size.txt')

## Merge "Size" and "Sample" datasets together
Size_Sample <- left_join(Sample, Size, by = c("SourceID","SiteID"))
nrow(Size_Sample)

## Save the new dataset
write.csv(Size_Sample , "data/Data_Size Across_flow_diagram.csv", row.names = TRUE)

################################################################################################################
#
# FIGURE 1
#
################################################################################################################
## Merge "Source" and "Sample" datasets together (and eliminate duplicates)
Source_Sample <- left_join(x = Source, y = Sample, by = "SourceID") %>%
  group_by(SourceID) %>% 
  filter(rank(SourceID, ties.method = "first") == 1)  
## Remove terrestrial ecosystems
Source_Sample.Aquatic <- Source_Sample %>%
  filter(!Ecosystem %in% "Terrestrial")

#### Year of publication (panel 1B)
Publication.Year <- ggplot(Source_Sample.Aquatic, aes(x = PublicationYear, fill = Ecosystem)) +
  geom_histogram(alpha = .8, color = "#e9ecef") +
  #scale_colour_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  scale_fill_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  coord_cartesian(xlim = c(1990, 2024)) +
  scale_x_continuous(breaks = c(1990, 1994, 1998, 2002, 2006, 
                                2010, 2014, 2018, 2022, 2024)) +
  xlab("Year of publication") +
  ylab("Number of studies") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_line(color = "black"),
        axis.text.x = element_text(color = "black", size = 12, angle = 40, vjust = 1, hjust = 1),
        axis.title.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

#### Taxonomic group (panel 1C)
## Rename categories within "SpeciesType"
Source_Sample.Aquatic <- Source_Sample.Aquatic %>%
  mutate(SpeciesType = as.character(SpeciesType),
         SpeciesType = if_else(SpeciesType == "Macroinvertebrates", "Macroinvertebrate", SpeciesType),
         SpeciesType = if_else(SpeciesType == "PrimProd+Zooplankton", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "Bacteria+Zooplankton", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "Bacteria+PrimProd", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "Bacteria+PrimProd+Zooplankton", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "PrimProd+Protozoan+Macroinvertebrate", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "PrimProd+Protozoan+Zooplankton", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "PrimProd+Zooplankton+Fish", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "Bacteria+Protozoan+Macroinvertebrate", "Others", SpeciesType),
         SpeciesType = if_else(SpeciesType == "Bacteria+PrimProd+Protozoan+Zooplankton", "Others", SpeciesType),
         SpeciesType = as.factor(SpeciesType))

## Re-order "SpeciesType"
Source_Sample.Aquatic$SpeciesType <- ordered(Source_Sample.Aquatic$SpeciesType, 
                                             levels = c("Fish", "Zooplankton", "Macroinvertebrate",
                                                        "Macroinvertebrate+Fish", "Zooplankton+Macroinvertebrate",
                                                        "Zooplankton+Fish", "Others"))
Taxonomic.Group <- ggplot(Source_Sample.Aquatic, aes(x = SpeciesType, fill = Ecosystem)) +
  geom_histogram(stat = "count", alpha = .8, color = "#e9ecef") +
  #scale_colour_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  scale_fill_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  ylab("Number of studies") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_line(color = "black"),
        axis.text.x = element_text(color = "black", size = 12, angle = 40, vjust = 1, hjust = 1),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

#### Locations of observational studies (panel 2A)
Full <- read.csv("data/Data_Size Across_flow_diagram.csv", header = T)
Full$SourceID <- as.factor(Full$SourceID); Full$SiteID <- as.factor(Full$SiteID); Full$SampleID <- as.factor(Full$SampleID);
Full$Hemisphere <- as.factor(Full$Hemisphere); Full$Realms <- as.factor(Full$Realms);
Full$GeographicalTerritory <- as.factor(Full$GeographicalTerritory); Full$GeographicalTerritory2 <- as.factor(Full$GeographicalTerritory2);
Full$Ecosystem <- as.factor(Full$Ecosystem); Full$EcosystemSpecification <- as.factor(Full$EcosystemSpecification); 
Full$Habitat <- as.factor(Full$Habitat); Full$BiologicalOrganisation <- as.factor(Full$BiologicalOrganisation);
Full$SizeSpectrumMethod <- as.factor(Full$SizeSpectrumMethod)
## Remove terrestrial ecosystems
Aquatic <- Full %>%
  filter(!Ecosystem %in% "Terrestrial")
## Create a new df with relevant information
coord.A <- tibble(SourceID = Aquatic$SourceID, SiteID = Aquatic$SiteID,
                  Ecosystem = Aquatic$Ecosystem,
                  GeographicalTerritory = Aquatic$GeographicalTerritory, GeographicalTerritory2 = Aquatic$GeographicalTerritory2,
                  Realms = Aquatic$Realms,
                  long = Aquatic$GeographicalLongitude, lat = Aquatic$GeographicalLatitude) 

## Create a bubble map where the sizes of the bubbles are proportional to the # articles in each Geographical Territory 2 (i.e. countries...)
## Calculate the number of studies per Geographical Territory 2
Aquatic_count <- Aquatic %>% group_by(GeographicalTerritory2) %>% summarise(count = n_distinct(SourceID))  
## Calculate the mean coordinate per Geographical Territory 2
Aquatic_avg.coordinates <- Aquatic %>% group_by(GeographicalTerritory2) %>% 
  summarise(across(GeographicalLatitude:GeographicalLongitude, ~mean(.x, na.rm = TRUE))) %>% 
  rename(Lat_avg = GeographicalLatitude, Long_avg = GeographicalLongitude)
## Merge the two dataframe
Aquatic_map <- left_join(Aquatic_count, Aquatic_avg.coordinates, by = "GeographicalTerritory2")
## Add the "Realms" to the new dataframe (and eliminate duplicates)
Aquatic_map <- merge(x = Aquatic_map, y = coord.A, by = "GeographicalTerritory2", all.x = TRUE) %>%
  group_by(GeographicalTerritory2) %>% 
  filter(rank(GeographicalTerritory2, ties.method = "first") == 1)
## Load the map
world_map <- map_data("world")
## Color palettes
library(ghibli)
PonyoMedium.2 <- ghibli_palette("PonyoMedium", 8, type = "continuous")
## Create breaks for the color scale
mybreaks <- c(1, 4, 8, 12, 16)
Map.Across <- ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill="grey", alpha = 0.5) +
  #geom_point(data = coord.A, aes(x = long, y = lat, size = 0.3, color = Realms, fill = Realms), shape = 1, alpha = 0.4) +
  geom_point(data = Aquatic_map, aes(x = Long_avg, y = Lat_avg, size = count, color = Realms, fill = Realms), stroke = 1.5, shape = 21, alpha = 0.6) +
  scale_size_continuous(range = c(2,12), breaks = mybreaks, name = "# articles") +
  scale_fill_manual(values = PonyoMedium.2) +
  scale_colour_manual(values = PonyoMedium.2) +
  ylab("Latitude") +
  xlab("Longitude") +
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_text(color = "black", size = 12),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.text = element_text(size = 12)) +
  guides(colour = guide_legend(override.aes = list(size = 4))) 

### Merge panels together
ggdraw() +
  draw_plot(Map.Across, x = 0, y = 0.5, width = 1, height = 0.5) +
  draw_plot(Publication.Year, x = 0, y = 0.08, width = .5, height = .4) +
  draw_plot(Taxonomic.Group, x = .5, y = 0.0, width = .5, height = .48) +
  draw_plot_label(label = c("(A)", "(B)", "(C)"), size = 15,
                  x = c(0, 0, 0.5), y = c(1, 0.5, 0.5))

################################################################################################################
#
# FIGURE 3
#
################################################################################################################
#### Size spectrum methods 
## Merge "Size" and "Sample" datasets together (BUT DO NOT remove duplicates)
## Remove terrestrial ecosystems
## Transform "SizeSpectrumMethod" variable into a factor
## Rename the levels of "SizeSpectrumMethod"
Size_Sample.Aquatic <- full_join(Sample, Size, by = c("SourceID", "SiteID")) %>%
  filter(!Ecosystem %in% "Terrestrial") %>% 
  mutate(SizeSpectrumMethod = as.factor(SizeSpectrumMethod)) %>% 
  mutate(SizeSpectrumMethod  = factor(SizeSpectrumMethod, labels = c("ASS", "BSS", "MLE", "NASS", "NBSS", "Pareto")))
nrow(Size_Sample.Aquatic)

SizeSpectrum.Methods <- ggplot(Size_Sample.Aquatic, aes(x = fct_infreq(SizeSpectrumMethod),  fill = Ecosystem)) +
  geom_bar(alpha = .8, color = "#e9ecef") +
  scale_fill_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  ylab("Occurence") +
  coord_cartesian(ylim = c(0, 3000)) +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_line(color = "black"),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")


################################################################################################################
#
# FIGURE 4
#
################################################################################################################
#### Size spectrum parameters distribution (lower panels)
Slope <- ggplot(Size_Sample.Aquatic, aes(x = fct_infreq(SizeSpectrumMethod), y = Slope)) +
  geom_boxplot(size = 0.6, width = 0.25, outlier.color = NA) +
  geom_half_violin(aes(x = SizeSpectrumMethod), scale = "width", colour = NA, fill = "grey70",  position = position_nudge(x = -0.16), trim = "FALSE", side = "l") +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.4,  size = 1.7, shape = 1, alpha = 0.4, position = position_nudge(x = 0.06)) +
  ylab("Size spectrum slope parameter") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

## Remove the factor level "MLE" because there is no intercept values
Size_Sample.Aquatic.Intercept <- Size_Sample.Aquatic  %>% 
  filter(!is.na(Intercept))
Intercept <- ggplot(Size_Sample.Aquatic.Intercept, aes(x = fct_infreq(SizeSpectrumMethod), y = Intercept)) +
  geom_boxplot(size = 0.6, width = 0.25, outlier.color = NA) +
  geom_half_violin(aes(x = SizeSpectrumMethod), scale = "width", colour = NA, fill = "grey70", position = position_nudge(x = -0.16), trim = "FALSE", side = "l") +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.4,  size = 1.7, shape = 1, alpha = 0.4, position = position_nudge(x = 0.06)) +
  ylab("Size spectrum intercept parameter") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

Linearity <- ggplot(Size_Sample.Aquatic, aes(x = fct_infreq(SizeSpectrumMethod), y = Linearity)) +
  geom_boxplot(size = 0.6, width = 0.25, outlier.color = NA) +
  geom_half_violin(aes(x = SizeSpectrumMethod), scale = "width", colour = NA, fill = "grey70", position = position_nudge(x = -0.16), trim = "FALSE", side = "l") +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.4,  size = 1.7, shape = 1, alpha = 0.4, position = position_nudge(x = 0.06)) +
  ylab("Size spectrum linearity parameter") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

#### END OF THE CODE