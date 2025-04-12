# COVID-nHMM-Chile

This repository contains the complete analytical pipeline and manuscript materials for the study:

> **"Mobility Restrictions and Structural Inequality in the Evolution of COVID-19: A Non-Homogeneous Hidden Markov Model Approach Applied to Santiago, Chile."**

---

## Project Structure

```
covid-nhmm-chile/
├── data/
│   ├── raw/                    # Original data (not committed)
│   └── processed/              # Preprocessed and merged data
│
├── notebooks/                 # Jupyter notebooks for each analysis stage
│
├── src/                       # Python modules and scripts
│
├── results/
│   ├── figures/               # High-quality figures for the manuscript
│   └── tables/                # Tables generated in the analysis
│
├── paper/                     # Manuscript drafts and BibTeX references
│
├── setup_env.ps1              # PowerShell script to create environment and install dependencies
├── requirements.txt           # Python package dependencies
└── README.md
```

## Environment Setup
This project requires **Python ≥ 3.11** and **R ≥ 4.5.0**.  

**Note:** We use `rpy2` to interface with R and require that the R executable is added to your PATH.
---

### Windows Setup (via PowerShell):

1. **Clone the repository:**

```bash
   git clone https://github.com/your-user/covid-nhmm-chile.git
   cd covid-nhmm-chile
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
    git clone https://github.com/your-user/covid-nhmm-chile.git
    cd covid-nhmm-chile
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
    Using lme4 in R, we model the probability of transition between states as a function of mobility and sociodemographic covariates. Random effects for communes and dates account for spatiotemporal heterogeneity. Covariate selection is guided via Elastic Net regression (using glmnet).

- Visualization:
    Figures are generated in Python (with matplotlib and seaborn) and network visualizations are created in Gephi with a circular layout to ensure legibility. Node colors and additional metadata (e.g., per capita income, with “CLP” prefixed to values) are assigned according to the CSV files.
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

## Analysis Overview
1. Data Preprocessing:
    Epidemiological data (daily and cumulative COVID-19 cases), mobility indices (internal and external), and sociodemographic variables (per capita income, household size, education level, housing conditions, Social Priority Index) were obtained from official records, anonymized cellphone logs, and government sources.

2. Modeling COVID-19 Dynamics:
    A non-homogeneous Hidden Markov Model was fitted to capture epidemic phases across communes:

    - State 1 — Controlled Transmission: ~5.2 daily cases/10,000 inhabitants; highest mobility (internal: ~4.2; external: ~6.0); dominant in affluent communes.

    - State 2 — Accelerated Transmission: ~15.4 daily cases; moderate decline in mobility (internal: ~3.2; external: ~5.3); associated with increasing overcrowding and lower education.

    - State 3 — Critical Transmission: ~55.4 daily cases; lowest mobility (internal: ~2.6; external: ~4.7); prevalent in structurally vulnerable communes.

    A clear gradient of socioeconomic inequality was observed: per capita income decreases (e.g., CLP 820,000 for Vitacura vs. CLP 320,000 for La Pintana), and housing overcrowding and deprivation increase from State 1 to State 3.

3. Transition Probabilities & Visualization:
    State transitions (including self-loops for state maintenance) and emission probabilities were extracted to build network visualizations. Comparative network graphs for representative communes (e.g., Vitacura vs. La Pintana) showcase how transitions change with mobility; for instance, nodes are colored accordingly (green for State 1, yellow for State 2, and red for State 3) and annotated with key metrics.

4. Policy Implications and Discussion:
    The modeling reveals that uniform, city-wide interventions may be ineffective unless tailored to local structural conditions. Public health policies should address underlying inequalities to improve epidemic control.
---

## Manuscript & Reproducibility
- The manuscript drafts (for submission to Nature) are located in the paper/ folder.
- All scripts and notebooks generate publication-quality figures stored in the results/figures/ folder.
- Code and datasets are versioned with Git; a comprehensive requirements.txt ensures reproducibility of the computational environment.
---

## License & Citation
This project is licensed under the MIT License.

If you use or adapt this work, please cite:

Herrera M., Neira C., Lagos F. (2025). Mobility Restrictions and Structural Inequality in the Evolution of COVID-19: A Non-Homogeneous HMM Approach Applied to Santiago, Chile. Nature (Preprint or DOI).
---

## Contact
For questions or further collaboration, please contact:

- Mauricio Herrera - mherrera@udd.cl
- Constanza Neira - cneirau@udd.cl
- Fernando Lagos – f.lagosa@udd.cl
---

## Supplementary: Setting Up the Environment with setup_env.ps1
The included script setup_env.ps1 automates the following on Windows:

- Creation of the virtual environment (nhmm)
- Installation of Python dependencies from requirements.txt
- Configuration to ensure R (version 4.5.0 or later) is available in your PATH

Simply run it in PowerShell within the project root directory.