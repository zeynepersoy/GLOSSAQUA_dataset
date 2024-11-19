

## Load packages
library(here)
library(dplyr) 
library(maps)
library(scico)
library(ggplot2)
library(cowplot)
library(forcats)         
library(gghalves)
library(ghibli)

## Load the data
Source <- read.table(here("data", "GLOSSAQUA_DataSource.txt"), header = TRUE)
Sample <- read.table(here("data", "GLOSSAQUA_Sample.txt"), header = TRUE)
Size <- read.table(here("data", "GLOSSAQUA_Size.txt"), header = TRUE)

################################################################################################################
#
# FIGURE 1
#
################################################################################################################

#### Locations of observational studies (panel 1A)
## Merge "Size" and "Sample" datasets together
## Convert negative Longitude values for Fiji into absolute values (to draw the map)
Size_Sample.map <- left_join(Sample, Size, by = c("StudyID","SiteID")) %>% 
  mutate(across(GeographicalLongitude, ~ifelse(GeographicalTerritory2=='Fiji', abs(.x), .x)))

## Create a new df with relevant information
coord.A <- tibble(StudyID = Size_Sample.map$StudyID, SiteID = Size_Sample.map$SiteID,
                  Habitat = Size_Sample.map$Habitat,
                  GeographicalTerritory = Size_Sample.map$GeographicalTerritory, GeographicalTerritory2 = Size_Sample.map$GeographicalTerritory2,
                  Realm = Size_Sample.map$Realm,
                  long = Size_Sample.map$GeographicalLongitude, lat = Size_Sample.map$GeographicalLatitude) 

## Create a bubble map where the sizes of the bubbles are proportional to the # articles in each Geographical Territory 2 (i.e. countries...)
## Calculate the number of studies per Geographical Territory 2
Aquatic_count <- Size_Sample.map %>% group_by(GeographicalTerritory2) %>% summarise(count = n_distinct(StudyID))  
## Calculate the mean coordinate per Geographical Territory 2
Aquatic_avg.coordinates <- Size_Sample.map %>% group_by(GeographicalTerritory2) %>% 
  summarise(across(GeographicalLatitude:GeographicalLongitude, ~mean(.x, na.rm = TRUE))) %>% 
  rename(Lat_avg = GeographicalLatitude, Long_avg = GeographicalLongitude)
## Merge the two dataframe
Aquatic_map <- left_join(Aquatic_count, Aquatic_avg.coordinates, by = "GeographicalTerritory2")
## Add the "Realm" to the new dataframe (and eliminate duplicates)
Aquatic_map <- merge(x = Aquatic_map, y = coord.A, by = "GeographicalTerritory2", all.x = TRUE) %>%
  group_by(GeographicalTerritory2) %>% 
  filter(rank(GeographicalTerritory2, ties.method = "first") == 1)
## Load the map
world_map <- map_data("world")
## Color palettes
PonyoMedium.2 <- ghibli_palette("PonyoMedium", 8, type = "continuous")
## Create breaks for the color scale
mybreaks <- c(1, 4, 8, 12, 16)
Map.Across <- ggplot() +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), fill="grey", alpha = 0.5) +
  #geom_point(data = coord.A, aes(x = long, y = lat, size = 0.3, color = Realm, fill = Realm), shape = 1, alpha = 0.4) +
  geom_point(data = Aquatic_map, aes(x = Long_avg, y = Lat_avg, size = count, color = Realm, fill = Realm), stroke = 1.5, shape = 21, alpha = 0.6) +
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

#### Year of publication (panel 1B)
## Merge "Source" and "Sample" datasets together (and eliminate duplicates)
Source_Sample.Aquatic <- left_join(x = Source, y = Sample, by = "StudyID") %>%
  group_by(StudyID) %>% 
  filter(rank(StudyID, ties.method = "first") == 1)  

Publication.Year <- ggplot(Source_Sample.Aquatic, aes(x = PublicationYear, fill = Habitat)) +
  geom_histogram(alpha = .8, color = "#e9ecef") +
  #scale_colour_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  scale_fill_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  coord_cartesian(xlim = c(1990, 2024)) +
  scale_x_continuous(breaks = c(1990, 1994, 1998, 2002, 2006, 2010, 2014, 2018, 2022, 2024)) +
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
                                             levels = c("Fish", "Zooplankton", "Macroinvertebrate", "Macroinvertebrate+Fish", "Zooplankton+Macroinvertebrate", "Zooplankton+Fish", "Others"))


## Create a new frequency table
freq_table <- Source_Sample.Aquatic %>%
  group_by(SpeciesType, Habitat) %>%
  summarise(frequency = n()) %>%
  arrange(desc(frequency))

Taxonomic.Group <- ggplot(freq_table, aes(x = SpeciesType, y = frequency, fill = Habitat)) +
  geom_bar(stat = "identity", alpha = .8, color = "#e9ecef") +
  scale_fill_manual(values = c("#66a61e", "#17becf", "#9467bd")) +
  ylab("Number of studies") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.ticks.x = element_line(color = "black"),
        axis.text.x = element_text(color = "black", size = 11, angle = 40, vjust = 1, hjust = 1),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 11),
        axis.title.y = element_text(color = "black", size = 11),
        legend.position = "none")


### Merge panels together
ggdraw() +
  draw_plot(Map.Across, x = 0, y = 0.5, width = 1, height = 0.5) +
  draw_plot(Publication.Year, x = 0, y = 0.08, width = .5, height = .4) +
  draw_plot(Taxonomic.Group, x = .5, y = 0.0, width = .5, height = .48) +
  draw_plot_label(label = c("(A)", "(B)", "(C)"), size = 15,
                  x = c(0, 0, 0.5), y = c(1, 0.5, 0.5))
ggsave(here("figures", "Figure 1.jpg"), width = 10, height = 10, units = 'in', dpi= 300)


################################################################################################################
#
# FIGURE 3
#
################################################################################################################
#### Size spectrum methods 
## Merge "Size" and "Sample" datasets together (BUT DO NOT remove duplicates)
## Transform "SizeSpectrumMethod" variable into a factor
## Rename the levels of "SizeSpectrumMethod"
Size_Sample <- full_join(Sample, Size, by = c("StudyID", "SiteID")) %>%
  mutate(SizeSpectrumMethod = as.factor(SizeSpectrumMethod)) %>% 
  mutate(SizeSpectrumMethod  = factor(SizeSpectrumMethod, labels = c("ASS", "BSS", "MLE", "NASS", "NBSS", "Pareto")))

SizeSpectrum.Methods <- ggplot(Size_Sample, aes(x = fct_infreq(SizeSpectrumMethod),  fill = Habitat)) +
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

ggsave(here("figures", "Figure 3.jpg"), width = 5, height = 5, units = 'in', dpi= 300)

################################################################################################################
#
# FIGURE 4
#this code only reproduces the lower panel of Figure 4
#
################################################################################################################
#### Size spectrum parameters distribution (lower panel of Figure 4)
Slope <- ggplot(Size_Sample, aes(x = fct_infreq(SizeSpectrumMethod), y = Slope)) +
  geom_boxplot(size = 0.6, width = 0.3, outlier.color = NA) +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.7,  size = 2, shape = 19, alpha = 0.3, position = position_nudge(x = 0.08)) +
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
Size_Sample.Intercept <- Size_Sample %>% 
  filter(!is.na(Intercept))
Intercept <- ggplot(Size_Sample.Intercept, aes(x = fct_infreq(SizeSpectrumMethod), y = Intercept)) +
  geom_boxplot(size = 0.6, width = 0.3, outlier.color = NA) +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.7,  size = 2, shape = 19, alpha = 0.3, position = position_nudge(x = 0.08)) +
  ylab("Size spectrum intercept parameter") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

Linearity <- ggplot(Size_Sample, aes(x = fct_infreq(SizeSpectrumMethod), y = Linearity)) +
  geom_boxplot(size = 0.6, width = 0.3, outlier.color = NA) +
  geom_half_point(aes(x = SizeSpectrumMethod), colour = "grey70", side = "r", range_scale = 0.7,  size = 2, shape = 19, alpha = 0.3, position = position_nudge(x = 0.08)) +
  ylab("Size spectrum linearity parameter") +
  theme_linedraw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(color = "black", size = 12),
        axis.title.x = element_blank(),
        axis.text.y = element_text(color = "black", size = 12),
        axis.title.y = element_text(color = "black", size = 12),
        legend.position = "none")

ggsave(here("figures", "Figure 4_LowerPanel.jpg"), width = 12, height = 6, units = 'in', dpi= 300)


#### END OF THE CODE
