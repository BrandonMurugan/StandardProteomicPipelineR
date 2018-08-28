dataImport <- function(txtpath){
  
  library(grid)
  library(XML)
  library(xml2)
  library(dplyr)
  library(reshape2)
  library(tidyr)
  library(here)
  library(splitstackshape)
  # setwd(here())
  # load("images/imported_Data")

  # DEBUGGING: Choose directory (MQ txt directory) and list txt files there ####
  # txtpath <- "C:/Users/Brandon/Documents/example_txt"
  direct <- txtpath

  # # Import path (and other details) from python: ####
  # summarySettings <- read.delim("temp/summarySettings.txt", sep = "\t", header = F, stringsAsFactors = F, row.names = "V1")
  # txtPath <- summarySettings["PATH",]
  # direct <- summarySettings["PATH",]

  # Rip info from mqpar file (also moved into text folder; less work on user's part) ####
  mqpar <- xmlTreeParse(file = paste0(direct,"//mqpar.xml"))
   # mqpar <- read_xml(paste0(direct,"\\mqpar.xml"))
  topMqpar <- xmlRoot(mqpar)
   # topMqpar <- xml_root(mqpar)
  topMqpar <- xmlApply(topMqpar, function(x) xmlSApply(x, xmlValue))
   # topMqpar <- xml2::(topMqpar)
   # mqpar_df <- data.frame(t(topMqpar), row.names = NULL)
  mqpar_df <- data.frame(t(topMqpar), row.names = NULL)

  expDesign <- data.frame(mqpar_df$filePaths)
  expDesign$experiments <- data.frame(mqpar_df$experiments)
  experiments <<- expDesign$experiments
  Intensity.experiments <- paste("Intensity",experiments$experiments,sep=".")
  expType <- data.frame(mqpar_df$restrictMods)

  # set experiment title based on raw file folder name (for report filename)
  parentFolder <- as.character(expDesign$filePaths[1])
  parentFolder <- strsplit(parentFolder, split = "\\\\")
  parentFolder <- unlist(parentFolder)
  parentFolder <- parentFolder[length(parentFolder)-1]
  versionNumber <- data.frame(mqpar_df$maxQuantVersion)
  # dir.create("/temp", showWarnings = T)   #made in python
  save(versionNumber, file = paste0(direct,"/temp/versionNumber"), compress = T)

  # Import txt files ####
  peptides <- read.delim(file = paste0(direct,"//peptides.txt"))
  proteinGroups <- read.delim(file = paste0(direct,"//proteinGroups.txt"))
  summary <- read.delim(file = paste0(direct,"//summary.txt"))
  if (grepl("Phos", expType[1,]) == TRUE){
    PhosphoSTYsites <- read.delim(file = paste0(direct,"//Phospho (STY)Sites.txt"))
  }
  # dir.create("/images", showWarnings = T)   #made in python
  # save.image(file = paste0(direct,"/images/imported_Data"), compress = T)
  save(list = ls(all.names = TRUE), file = paste0(direct,"/images/imported_Data.RData"))
}