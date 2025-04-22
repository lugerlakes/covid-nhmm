# install_packages.R
# Script to install required R packages for COVID-nHMM-Chile project

required_packages <- c("depmixS4", "lme4", "glmnet", "ggplot2", "data.table", "localconverter","httpgd","base","utils","hrbrthemes","dplyr","tidyr","ggthemes","ggpubr","ggsci","viridis","sf")

# Set CRAN mirror (cloud-based, stable)
options(repos = c(CRAN = "https://cloud.r-project.org"))

install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("📦 Installing package: %s", pkg))
    install.packages(pkg)
  } else {
    message(sprintf("✅ Package already installed: %s", pkg))
  }
}

invisible(sapply(required_packages, install_if_missing))
