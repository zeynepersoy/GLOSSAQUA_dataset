# GLOSSAQUA_dataset <img src="other/logo_across.png" align="right" height="220" width="210" ></a>

This is the GitHub repository of "GLOSSAQUA: a GLObal dataset of Size Spectra across AQUAtic ecosystems" presented in Ersoy et al. 2024.

The dataset was financially supported by the([Iberian Society of Ecology](https://www.sibecol.org/en/)) Advanced Early Career Researchers Project Grant (ACROSS project).

Dataset last updated: 14.08.2024


## About the project and contact information

If you want to know more about the project, please check the [project's webpage](https://across.netlify.app/).

Project Co-PIs: 

<a href="https://www.ignasiarranz.com/" target="_blank">Ignasi Arranz</a> (University of Rey Juan Carlos, Spain)

<a href="https://charlotteevangelista.weebly.com/" target="_blank">Charlotte Evangelista</a> (Norwegian Institute for Nature Research, Norway)

<a href="https://zeynepersoy.com/" target="_blank">Zeynep Ersoy</a> (University of Barcelona, Spain)


## Repository structure

This repository holds the data files, the figures presented in Ersoy et al. 2024 and the R code used to reproduce them (Figures_GLOSSAQUA dataset.R), and the R code to standardize size spectra parameters (Standardization_GLOSSAQUA dataset.R).

The data files can be found in the data folder, while the figures can be found in the graphs folder.

The repository uses different packages (e.g., dplyr, maps, scico, ggplot2, cowplot, forcats, gghalves, ghibli) that can all be installed from CRAN using the install.packages(“package name”) code syntax.


## Data structure

GLOSSSAQUA compiles a comprehensive collection of size spectra parameters (i.e. slope, intercept and linearity) across aquatic ecosystems and trophic levels. Data were acquired from two different sources: a classic literature review and an online survey.

To be included in the GLOSSAQUA dataset, all studies had to meet the following criteria: (1) to be field-based studies and hence, experimental (including in situ experiments) or theoretical studies were excluded; (2) to involve animal communities and hence, primary producers were excluded unless they were part of a food web (e.g., phytoplankton-zooplankton-fish); and (3) to be studies based on individual body size measurements without relying on mean or maximum body size per species.

For studies derived from the literature review, we extracted size spectrum parameters (e.g., slope, intercept and linearity) directly from tables or by digitizing information from plots using WebPlotDigitizer software v.3.4 (Rohatgi 2020). For studies derived from the online survey (i.e., individual body size datasets), we calculated size spectra parameters following the fitting recommendation provided by Sprules (2022). 

For all studies, we also extracted additional information related to geographic location, ecosystem type, taxonomic groups, sampling method and period (mainly month), size spectrum method, number of size classes and minimum and maximum size classes. 
 


## How to contribute to GLOSSAQUA

If you have size spectrum data that follow the criteria described above, please
<a href='mailto:ignasi.arranz@urjc.es,charlotte.evangelista0@gmail.com,zzeynepersoy@gmail.com'>contact us</a> and we would be happy to add your data to the GLOSSAQUA dataset.


