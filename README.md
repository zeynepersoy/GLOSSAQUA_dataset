# GLOSSAQUA_dataset

This is the GitHub repository of "GLOSSAQUA: a GLObal dataset of Size Spectra across AQUAtic ecosystems" presented in Ersoy et al. 2024.

The dataset was financially supported by the [Iberian Society of Ecology](https://www.sibecol.org/en/) Advanced Early Career Researchers Project Grant (ACROSS project).

Dataset last updated: 14.08.2024


## About the project and contact information

If you want to know more about the project, please check the [project's webpage](https://across.netlify.app/).

Project Co-PIs: 

<a href="https://www.ignasiarranz.com/" target="_blank">Ignasi Arranz</a> (University of Rey Juan Carlos, Spain)

<a href="https://charlotteevangelista.weebly.com/" target="_blank">Charlotte Evangelista</a> (Norwegian Institute for Nature Research, Norway)

<a href="https://zeynepersoy.com/" target="_blank">Zeynep Ersoy</a> (University of Barcelona, Spain)


## Repository structure

This repository holds two folders called "data" and "figures"  presented in Ersoy et al. 2024 and the R code used to reproduce them (`Figures_GLOSSAQUA dataset.R`), and the R code to standardize size spectra parameters (`Standardization_GLOSSAQUA dataset.R`).

More details on how to [clone](https://docs.github.com/en/repositories/creating-and-managing-repositories/cloning-a-repository) or [fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) this repository can be find in the linked websites.

`Figures_GLOSSAQUA dataset.R`: This script loads the data files from data folder and merge them to reproduce the figures in the manuscript.

`Standardization_GLOSSAQUA dataset.R`: This scripts transforms the theoretical values of the size spectrum slopes based on [Sprules and Barth 2016](https://cdnsciencepub.com/doi/abs/10.1139/cjfas-2015-0115) and [Guiet et al. 2016] (https://www.sciencedirect.com/science/article/abs/pii/S0304380016301958).

The repository uses different packages (e.g., `dplyr`, `maps`, `scico`, `ggplot2`, `cowplot`, `forcats`, `gghalves`, `ghibli`) that can all be installed from CRAN using the `install.packages(“package name”)` code syntax.

The data folder holds four tab-delimited TXT files, while the figures can be found in the figures folder.

`GLOSSAQUA_Dictionary.txt`  integrates the description of all variables present in the other TXT files. Each row corresponds to a variable while the columns contain the name of the variable and its description, an example, and the name of the TXT files where this variable can be found

`GLOSSAQUA_DataSource.txt` represents the article and datasets used to collect size spectra parameters. Each row corresponds to a study while the columns contain the article identification, the abbreviated citation, the peer-reviewed journal, the year of publication and the Digital Object Identifier (DOI).

`GLOSSAQUA_Sample.txt` contains the information of each sample with its projected geographical coordinates in WGS84 (latitude and longitude). Each row corresponds to the sample while columns include the biogeographic realms (using boundaries defined by Olson et al. 2001), the type of ecosystem type, the environmental context, the level of ecological complexity, the organismal group and the sampling method.

`GLOSAQUASizeAcross_Size.txt` compiles information related to the size spectrum methodology and parameters. Each row corresponds to the individual estimates of size spectra parameters, while the columns include the size spectra parameters (i.e., slope, intercept and linearity), body size units, and body size ranges.


## Data structure

GLOSSSAQUA compiles a comprehensive collection of size spectra parameters (i.e. slope, intercept and linearity) across aquatic ecosystems and trophic levels. Data were acquired from two different sources: a classic literature review and an online survey.

To be included in the GLOSSAQUA dataset, all studies had to meet the following criteria: (1) to be field-based studies and hence, experimental (including in situ experiments) or theoretical studies were excluded; (2) to involve animal communities and hence, primary producers were excluded unless they were part of a food web (e.g., phytoplankton-zooplankton-fish); and (3) to be studies based on individual body size measurements without relying on mean or maximum body size per species.

For studies derived from the literature review, we extracted size spectrum parameters (e.g., slope, intercept and linearity) directly from tables or by digitizing information from plots using WebPlotDigitizer software v.3.4 (Rohatgi 2020). For studies derived from the online survey (i.e., individual body size datasets), we calculated size spectra parameters following the fitting recommendation provided by [Sprules (2022)](https://www.sciencedirect.com/science/article/abs/pii/B9780128191668000244?via%3Dihub). 

For all studies, we also extracted additional information related to geographic location, ecosystem type, taxonomic groups, sampling method and period (mainly month), size spectrum method, number of size classes and minimum and maximum size classes. 
 


## How to contribute to GLOSSAQUA

If you have size spectrum data that follow the criteria described above, please
<a href='mailto:ignasi.arranz@urjc.es,charlotte.evangelista0@gmail.com,zzeynepersoy@gmail.com'>contact us</a> and we would be happy to add your data to the GLOSSAQUA dataset.


