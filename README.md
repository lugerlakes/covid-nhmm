# COVID-nHMM

This repository provides the complete analytical pipeline, datasets, and reproducible materials supporting the study:

> **"Inference of latent epidemic regimes and generative simulations reveal how inequality and mobility shape COVID-19 transmission"**  
> Authors: Mauricio Herrera-Marín, Constanza Neira-Urrutia, and Fernando Lagos-Alvarado  

---

## Project Overview

This repository hosts the complete analytical workflow, curated datasets, and computational implementations supporting the study.  
The **regime-aware, renewal-grounded framework** characterizes COVID-19 transmission across 34 communes of Santiago, Chile, during 2020.  
It integrates statistical inference, mixed-effects modeling, and generative simulation to quantify how **mobility and structural inequality jointly shaped epidemic dynamics**.

---

## Methodological Framework

The analytical pipeline integrates:

1. **Non-Homogeneous Hidden Markov Model (nHMM)**  
   - Covariate-dependent transitions with internal and external mobility and socioeconomic covariates.  
   - Commune-level random effects capture spatial heterogeneity.  
   - Fitted using `depmixS4` (R) via the `rpy2` bridge in Python.  
   - Competing models (3–10 states) were evaluated using log-likelihood, AIC, and BIC criteria, and a parsimonious **three-regime** structure was selected.

2. **Mixed-Effects Transition Modeling (GLMMs)**  
   - Implemented with `lme4` in R.  
   - Quantifies escalation and regression odds as functions of mobility and structural indicators (income, overcrowding, education, and urban quality).  
   - Reports fixed and random effects, variance components, and marginal/conditional R².

3. **Generative Simulation Engines**  
   - **Heteroscedastic CVAE–LSTM:** Learns short-memory temporal structure and regime-conditioned variability for calibrated predictive envelopes.  
   - **Severity-weighted Copula–GPD:** Captures cross-variable dependence (incidence–mobility) and tail behavior via peaks-over-threshold extremes.

4. **Renewal-Based Transmission Mapping**  
   - Converts simulated and observed incidence to **time-varying reproduction numbers (Rt)** using Cori and Wallinga–Teunis estimators.  
   - Ensures epidemiological coherence and consistent uncertainty propagation across modeling layers.

5. **Policy and Equity Insights**  
   - Regime transition probabilities provide early-warning signals (`Pr(St+1 > St)`) for supercritical phases.  
   - Regression odds quantify barriers to recovery in structurally vulnerable communes.

--- 

## Repository Structure

```
COVID-nHMM/
├── data/                      # Curated datasets
|   └── covid_data             
├── notebooks/                 # Jupyter notebooks: preprocessing, modeling, simulation
├── src/                       # Core R and Python source code
│   └── install_packages.R     # R dependency installer
├── results/
│   ├── figures/               # High-quality figures for publication
│   └── tables/                # Derived statistical tables
├── supplementary/             # Supplementary drafts
├── setup_env.ps1              # PowerShell script for environment setup
├── requirements.txt           # Python dependencies
└── README.md
```
---

## Environment Setup

### Requirements
- **Python ≥ 3.11**
- **R ≥ 4.5.0**
- Interface: `rpy2` for Python–R communication  
  (verify `R --version` is accessible in terminal).

### Windows Setup (via PowerShell):

1. **Clone the repository:**

```bash
   git clone https://github.com/your-user/covid-nhmm.git
   cd covid-nhmm
```
2. Run the setup script:

```bash
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

## Key Results
- Identified three latent epidemic regimes aligned with Rt thresholds (control, severe, critical).
- Demonstrated that mobility alone cannot explain escalation, which is strongly modulated by structural inequality.
- Produced calibrated, regime-aware Rt trajectories consistent with Cori and Wallinga-Teunis estimators.
- Quantified inter-communal variance (>84%) in transitions, revealing strong structural conditioning.
- Provided a reproducible, open-source framework for phase-aware epidemic surveillance.

---

## Manuscript & Reproducibility

- All analyses use open data aggregated at the commune level (no personal identifiers).
- Figures and tables for publication are generated in the results/
- Environments are controlled via requirements.txt and setup_env.ps1
- R package dependencies are listed in src/install_packages.R

---


## Authors

| **Author** | **Affiliation** | **Role** |
|-------------|-----------------|-----------|
| **Mauricio Herrera-Marín** | Faculty of Engineering, Universidad del Desarrollo, Santiago, Chile | Conceptualization, methodology, formal analysis, writing – *Corresponding author* |
| **Constanza Neira-Urrutia** | Faculty of Health Sciences, Universidad del Desarrollo, Concepción, Chile | Data curation, visualization, critical revision – *Equal contribution* |
| **Fernando Lagos-Alvarado** | Faculty of Engineering, Universidad del Desarrollo, Santiago, Chile | Data curation, coding, computational implementation, validation of analytical methods, critical revision – *Equal contribution* |

---

## License & Citation
MIT License.
© 2025 Universidad del Desarrollo & the Authors.

If you use or adapt this repository, please cite:

Herrera-Marín, M., Neira-Urrutia, C., & Lagos-Alvarado, F. (2025).
Inference of latent epidemic regimes and generative simulations reveal how inequality and mobility shape COVID-19 transmission.

---

## Contact
For questions or collaboration:

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

---

> Herrera-Marín, M., Neira-Urrutia, C., & Lagos-Alvarado, F. (2025).  
> *Inference of latent epidemic regimes and generative simulations reveal how inequality and mobility shape COVID-19 transmission.*  
