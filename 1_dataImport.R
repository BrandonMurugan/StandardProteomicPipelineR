dataImport <- function(){
  
  library(grid)
  library(XML)
  library(dplyr)
  library(reshape2)
  library(tidyr)
  library(splitstackshape)

  # DEBUGGING: Choose directory (MQ txt directory) and list txt files there ####
  txtPath <- "C:/Users/Brandon/Documents/example_txt"
  direct <- txtPath
  
  # # Import path (and other details) from python: ####
  # summarySettings <- read.delim("temp/summarySettings.txt", sep = "\t", header = F, stringsAsFactors = F, row.names = "V1")
  # txtPath <- summarySettings["PATH",]
  # direct <- summarySettings["PATH",]
  
  # Rip info from mqpar file (also moved into text folder; less work on user's part) ####
  mqpar <- xmlTreeParse(file = paste0(direct,"\\mqpar.xml"))
  topMqpar <- xmlRoot(mqpar)
  topMqpar <- xmlApply(topMqpar, function(x) xmlSApply(x, xmlValue))
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
  save(versionNumber, file = "temp/versionNumber", compress = T)
  
  # Import txt files ####
  peptides <<- read.delim(file = paste0(direct,"\\peptides.txt"))
  proteinGroups <<- read.delim(file = paste0(direct,"\\proteinGroups.txt"))
  summary <<- read.delim(file = paste0(direct,"\\summary.txt"))
  if (grepl("Phos", expType[1,]) == TRUE){
    PhosphoSTYsites <<- read.delim(file = paste0(direct,"\\Phospho (STY)Sites.txt"))
  }
}