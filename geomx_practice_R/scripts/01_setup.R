# scripts/01_setup.R

# CRAN package installer
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  install.packages("BiocManager")
}

# Check the Bioconductor version matched to the current R version
message("Bioconductor version: ", BiocManager::version())

# CRAN packages
cran_packages <- c(
  "tidyverse",
  "here",
  "renv"
)

missing_cran <- cran_packages[
  !vapply(cran_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_cran) > 0) {
  install.packages(missing_cran)
}

# Bioconductor packages
bioc_packages <- c(
  "SingleCellExperiment",
  "SummarizedExperiment",
  "scater",
  "scran",
  "edgeR",
  "limma",
  "NanoStringNCTools",
  "GeomxTools",
  "GeomxWorkflows",
)

missing_bioc <- bioc_packages[
  !vapply(bioc_packages, requireNamespace, logical(1), quietly = TRUE)
]

if (length(missing_bioc) > 0) {
  BiocManager::install(
    missing_bioc,
    ask = FALSE,
    update = FALSE
  )
}

message("Package setup completed.")