library(NanoStringNCTools)
library(GeomxTools)
library(GeoMxWorkflows)

# 2.1 Load Data

datadir <- system.file("extdata", "WTA_NGS_Example",
                       package = "GeoMxWorkflows")

DCCFiles <- dir(file.path(datadir, "dccs"), pattern = ".dcc$",
                full.names = TRUE, recursive = TRUE)
PKCFiles <- unzip(zipfile = dir(file.path(datadir, "pkcs"), pattern = ".zip$",
                                full.names = TRUE, recursive = TRUE))
SampleAnnotationFile <- dir(file.path(datadir, "annotation"), pattern = ".xlsx$", full.names = TRUE, recursive = TRUE)

demoData <- readNanoStringGeoMxSet(dccFiles = DCCFiles,
                           pkcFiles = PKCFiles,
                           phenoDataFile = SampleAnnotationFile,
                           phenoDataSheet = "Template",
                           phenoDataDccColName = "Sample_ID",
                           protocolDataColNames = c("aoi", "roi"),
                           experimentDataColNames = c("panel"))

# 3.1 Load Data

library(knitr)
pkcs <- annotation(demoData)
modules <- gsub(".pkc", "", pkcs)
kable(data.frame(PKCs = pkcs, modules = modules))

# 3.2 Sample Overview

library(dplyr)
library(ggforce)
library(networkD3)

sankeyCols <- c("source", "target", "value")

link1 <- count(pData(demoData), `slide name`, class)
link2 <- count(pData(demoData),  class, region)
link3 <- count(pData(demoData),  region, segment)

colnames(link1) <- sankeyCols
colnames(link2) <- sankeyCols
colnames(link3) <- sankeyCols

links <- rbind(link1,link2,link3)
nodes <- unique(data.frame(name=c(links$source, links$target)))

# sankeyNetwork is 0 based, not 1 based
links$source <- as.integer(match(links$source,nodes$name)-1)
links$target <- as.integer(match(links$target,nodes$name)-1)


plt <- sankeyNetwork(Links = links, Nodes = nodes, Source = "source",
              Target = "target", Value = "value", NodeID = "name",
              units = "TWh", fontSize = 12, nodeWidth = 30)

class(plt)

htmlwidgets::saveWidget(
    plt,
    "/workspaces/sc_tutorials/geomx_practice_R/figures/sankey.html",
    selfcontained = TRUE
)
