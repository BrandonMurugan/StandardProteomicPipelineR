dataPreprocess <- function(){
  library(dplyr)
  library(splitstackshape)
  
  # variables from Python
  QuantType <- summarySettings["QuantType",]
  NormType <- summarySettings["NormType",]
  
  # Remove Contaminants, Reverse hits ####
  proteinGroups <- read.delim("~/example_txt/proteinGroups.txt", sep = "\t")
  PGs <- proteinGroups
  PGs <- PGs[PGs$Potential.contaminant != "+" & PGs$Reverse != "+",]
  
  # Make Quantitation file (choose LFQ/Intensities from python GUI**) ####
  uniprot.IDs <- data.frame(Protein.ID = PGs$Majority.protein.IDs, stringsAsFactors = F)
  uniprot.IDs$Protein.ID <- as.character(uniprot.IDs$Protein.ID)
  uniprot.IDs <- cSplit(indt = uniprot.IDs, splitCols = "Protein.ID", sep = ";")
  uniprot.IDs <- data.frame(uniprot.IDs[,1])
  colnames(uniprot.IDs) <- "Protein.ID"

  if (QuantType == "Intensity"){
    intensity.PG <- cbind(uniprot.IDs, PGs[grep(colnames(PGs), pattern = "Intensity.")])
    intensity.PG$Protein.ID <- as.character(intensity.PG$Protein.ID)
    # Make quant file with common name despite LFQ/Intensity (makes downstream tasks easier)
    ProteinQuant <- intensity.PG
  }

  if (QuantType == "LFQ"){
    LFQ.PG <- cbind(uniprot.IDs, PGs[grep(colnames(PGs), pattern = "LFQ.")])
    LFQ.PG$Protein.ID <- as.character(LFQ.PG$Protein.ID)
    # Make quant file with common name despite LFQ/Intensity (makes downstream tasks easier)
    ProteinQuant <- LFQ.PG
  }
  
  # Normalise data (usually for Intensity data, Choose in python GUI**) ####
  if (NormType == "MedianCentre"){
    ProteinQuant[ProteinQuant == 0] <- NA
    ProteinQuant.norm <- ProteinQuant[,-1]
    ColumnMeans <- colMeans(ProteinQuant.norm, na.rm = T)
    meanMeans <- mean(ColumnMeans)
    normFactor <- meanMeans/ColumnMeans
    ProteinQuant.norm <- data.frame(mapply("*", ProteinQuant.norm, normFactor))
    ProteinQuant.norm <- cbind(Protein.ID = ProteinQuant[,1], ProteinQuant.norm)
  }
  
  # render these in python GUI (real time)?
  before <- ProteinQuant
  after <- ProteinQuant.norm
  boxplot(log(before[,-1], 2))
  boxplot(log(after[,-1], 2))
  
  if (QuantType == "Quantile"){
    # to be added
  }
  
  # TO ADD DECISION ON ZERO VALUE REMOVAL/IMPUTATION
  
  
  # TO POTENTIALLY ADD GRAPHS SHOWING DATA CONSISTENCY FOR QC?

  
  
  
  
  
  
  
  
  
  
  
  
}