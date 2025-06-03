# COVID-nHMM

This repository contains the complete analytical pipeline and manuscript materials for the study:

> **"Beyond Mobility: Socioeconomic Context Shapes the Dynamics and Hidden States of COVID-19 Transmission"**

---
## Project Overview

This repository contains the code, data, and analytical materials for the study Beyond Mobility: Socioeconomic Context Shapes the Dynamics and Hidden States of COVID-19 Transmission. Our integrative framework models the spatiotemporal progression of COVID-19 in urban communes, emphasizing the role of mobility patterns and structural socioeconomic factors.

## Methodology

The project employs **Non-Homogeneous Hidden Markov Models (nHMMs)** to identify latent epidemic states driven by internal and external mobility patterns and modulated by sociodemographic and structural covariates.

Using **linear mixed-effects models**, we analyze the heterogeneity in transition dynamics, demonstrating how urban quality and structural inequality shape epidemic persistence and regression.

To validate the inferred latent structures, we implement two simulation strategies:
- **Hybrid Copula–Generalized Pareto Distribution Model** to capture non-Gaussian dependency and tail risks.
- **Conditional Variational Autoencoder with LSTM (CVAE-LSTM)**, conditioned on latent states and commune-specific features.
We also introduce **severity-weighted data augmentation** to enhance the representation of critical epidemic regimes, improving the reproduction of epidemic peaks.


## Repository Structure

```
COVID-nHMM/
├── data/                      # Raw and processed data files
|   └── covid_data             
├── notebooks/                 # Jupyter notebooks for each analysis stage
├── src/                       # Python modules and scripts
│   └── install_packages.R # R script to install required R packages
├── results/
│   ├── figures/               # High-quality figures for the manuscript
│   └── tables/                # Tables generated in the analysis
├── paper/                     # Manuscript drafts and BibTeX references
├── setup_env.ps1              # PowerShell script to create environment and install dependencies
├── requirements.txt           # Python package dependencies
└── README.md
```

## Environment Setup
This project requires **Python ≥ 3.11** and **R ≥ 4.5.0**.  

> **Note:** We use `rpy2` to interface with R. Ensure that the R executable is available in your `PATH` environment variable. You can verify with `R --version` in a new terminal session.

---

### Windows Setup (via PowerShell):

1. **Clone the repository:**

```bash
   git clone https://github.com/your-user/covid-nhmm.git
   cd covid-nhmm
```
2. Run the setup script:

```powershell
    .\setup_env.ps1
```
This script creates a virtual environment named nhmm and installs all required dependencies from requirements.txt.
---

### macOS/Linux Setup:
1. **Clone the repository:**
 ```bash
    git clone https://github.com/your-user/covid-nhmm.git
    cd covid-nhmm
```
2. Create and activate the virtual environment:

```bash
    python3 -m venv nhmm
    source nhmm/bin/activate
```
3. Install dependencies:

```bash
    pip install -r requirements.txt
```
---

## Software and Computational Workflow
- Preprocessing:
    Time series data are smoothed using a 7-day moving average. Data are merged by date and commune using standardized keys.

- Hidden Markov Modeling (nHMM):
    We used the R package depmixS4 (accessed via rpy2) to estimate a non-homogeneous Hidden Markov Model. Transition probabilities vary as a function of internal and external mobility. Gaussian emission distributions are fitted to daily case counts, and parameters are optimized using the Expectation-Maximization (EM) algorithm. Competing models (with 3–10 states) were compared using log-likelihood, AIC, and BIC.

- Viterbi Decoding:
    The most probable sequence of hidden states (State 1: Controlled Transmission, State 2: Accelerated Transmission, State 3: Critical Transmission) is obtained using the Viterbi algorithm.

- Transition Modeling with Linear Mixed Models (LMMs):
    Using lme4 in R, we model the transition probability between states as a function of mobility and sociodemographic covariates. Random effects for communes and dates account for spatiotemporal heterogeneity. Covariate selection is guided via Elastic Net regression (using glmnet).

- Visualization:
    Figures are generated in Python (with matplotlib and seaborn), and network visualizations are created in Gephi with a circular layout to ensure legibility. Node colors and additional metadata (e.g., per capita income, with “CLP” prefixed to values) are assigned according to the CSV files.
---

## Key Dependencies
- Python:
    - pandas
    - numpy
    - matplotlib
    - seaborn
    - scikit-learn
    - statsmodels
    - rpy2
    - ipykernel

- R:
    - depmixS4
    - lme4
    - glmnet (for Elastic Net regularization)
---

## Modeling and Analysis    
1. Data Preprocessing:
    Epidemiological data (daily and cumulative COVID-19 cases), mobility indices (internal and external), and sociodemographic variables (per capita income, household size, education level, housing conditions, Social Priority Index) were obtained from official records, anonymized cellphone logs, and government sources.

    - Seven-day moving average applied to epidemiological time series.
    - Commune-level data fusion based on standardized keys.

2. nHMM Model:
    - Estimation of latent epidemic states using depmixS4 in R.
    - Transition probabilities modeled as functions of mobility and inequality indicators.
    - Model comparison across 3–10 states using AIC, BIC, and likelihood estimation.

3. Viterbi Decoding:
    - Identifying the most probable sequence of epidemic states:
        - State 1 — Moderated Transmission.
        - State 2 — Several Transmission.
        - State 3 — Critical Transmission.

4. Simulation Strategies:
    - Non-Gaussian dependency modeling using Copulas.
    - Deep learning-based epidemic simulation using CVAE-LSTM.

5. Key Contributions
    - Identification of latent transmission states beyond mobility-based models.
    - Empirical evidence highlighting structural inequalities in epidemic dynamics.
    - Advanced simulation techniques to enhance epidemic model fidelity.
    - Generalizable framework for infectious disease forecasting and policy design.

---

## Manuscript & Reproducibility

- The manuscript drafts (for submission to Nature) are in the paper/ folder.

- Figures and tables for publication are generated in the results/

- Environments are controlled via requirements.txt and setup_env.ps1

- R package dependencies are listed in src/install_packages.R

---

## Authors
- Mauricio Herrera-Marín (mherrera@udd.cl) * + – Faculty of Engineering, Universidad del Desarrollo, Santiago, Chile.
- Constanza Neira-Urrutia (c.neira@udd.cl) + – Faculty of Health Sciences, Universidad del Desarrollo, Concepción, Chile.
- Fernando Lagos-Alvarado (f.lagosa@udd.cl) + – Faculty of Engineering, Universidad del Desarrollo, Santiago, Chile.
- * Corresponding author.
- + These authors contributed equally to this work.
---

## License & Citation
This project is licensed under the MIT License.

If you use or adapt this work, please cite:

Mauricio Herrera-Marín, Constanza Neira-Urrutia, and Fernando Lagos-Alvarado (2025). *Beyond Mobility: Socioeconomic Context Shapes the Dynamics and Hidden States of COVID-19 Transmission*
---

## Contact
For questions or further collaboration, please contact:

- Mauricio Herrera-Marín -  mherrera@udd.cl
- Constanza Neira-Urrutia - c.neirau@udd.cl
- Fernando Lagos-Alvarado – f.lagosa@udd.cl
---

## Supplementary: 

### Setting Up the Environment with setup_env.ps1
The included script setup_env.ps1 automates the following on Windows:

- Creation of the virtual environment (nhmm)
- Installation of Python dependencies from requirements.txt
- Configuration to ensure R (version 4.5.0 or later) is available in your PATH

Simply run it in PowerShell within the project root directory.

###  install_packages.R
For convenience, you can install R packages via:
```R
source("src/install_packages.R")
```
Ensure that:

You’re in the project root or have set the working directory with setwd()

R ≥ 4.5.0 is installed and in your system PATH

