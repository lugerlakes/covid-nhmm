
# Numerical Corrections and Severity Weighting for Hidden Markov Model (HMM) States

# Required libraries
pacman::p_load(dplyr, ggplot2, hrbrthemes, ggsci, ggthemes,
               plotly, readxl, tidyr, copula, fitdistrplus, evd, stats)

# Explicitly defining function aliases to prevent namespace conflicts
select=dplyr::select
filter=dplyr::filter

# --- Global Plotting Theme Configuration ---
tema=theme(
  legend.position = "bottom",
  axis.title.x = element_text(color="black", size=14,family = "Arial Narrow"),
  axis.title.y = element_text(color="black", size=14,family = "Arial Narrow"),
  plot.title = element_text(color="black", size=20,family = "Arial Narrow",face='bold'),
  plot.subtitle = element_text(color="black", size=12,family = "Arial Narrow",face='italic'),
  axis.text=element_text(color="black", size=14,family = "Arial Narrow",face='italic')
)

# --- Data Loading and Preprocessing ---

# Define base path and load data
l <- '/Users/mauricioherrera/mis_env/covid-nhmm/notebooks'
ruta2 <- file.path(l, "covid_data_with_6_states.csv")
covid_data <- read.csv(ruta2)

# Convert necessary columns to appropriate formats
covid_data$Date <- as.Date(covid_data$Date)
covid_data$Commune <- as.factor(covid_data$Commune)

# Inspect data structure and unique communes
head(covid_data )
unique(covid_data$Commune)

# Define target communes and variables for copula modeling
comunas_objetivo <- c("La Florida", "Cerrillos", 
                      "Vitacura", "Providencia",
                      "Las Condes", "Santiago")
vars <- c("Gross_Daily_Cases_Mobile_Average_7_Days",
          "Internal_Mobility_Index", "External_Mobility_Index")

# --- Ranking HMM States by Severity ---

# Calculate the mean of daily cases for each Hidden State (severity ranking)
ranking_estados <- covid_data %>%
  group_by(Hidden_State) %>%
  summarise(media_casos = mean(Gross_Daily_Cases_Mobile_Average_7_Days, na.rm = TRUE)) %>%
  arrange(desc(media_casos))

# Assign weights based on severity rank
# CORRECTION: Assign the result of mutate back to ranking_estados
ranking_estados <- ranking_estados %>%
  mutate(peso = case_when(
    row_number() == 1 ~ 10,  # Super-critical state weight
    row_number() == 2 ~ 6,
    row_number() == 3 ~ 4,
    row_number() == 4 ~ 2,
    TRUE ~ 1
  ))

# Create a named vector for easy weight lookup
estado_pesos <- setNames(ranking_estados$peso, ranking_estados$Hidden_State)

cat("Ranking of HMM States by Severity:\n")
print(ranking_estados)

# --- Copula and GPD Fitting by Commune and State ---

# Initialize lists to store model fits
copulas_list <- list()
gpd_fits <- list()

for (com in comunas_objetivo) {
  for (state in sort(unique(covid_data$Hidden_State))) {
    subset <- covid_data %>%
      filter(Commune == com, Hidden_State == state) %>%
      select(all_of(vars))
    
    # Severity Weighted Replication
    # Replicate rows based on the assigned severity weight (peso)
    if (state %in% names(estado_pesos)) {
      peso <- estado_pesos[as.character(state)]
      subset <- subset[rep(1:nrow(subset), each = peso), ]
    }
    
    # Proceed with modeling only if enough data points exist
    if (nrow(subset) > 30) {
      # Empirical transformation to pseudo-observations (uniform margins)
      u_data <- pobs(as.matrix(subset)) 
      
      # Fit t-copula (multivariate dependence structure)
      cop <- tCopula(dim = 3, df = 5, dispstr = "un")
      fit <- fitCopula(cop, u_data, method = "ml", start = c(0.5, 0.5, 0.5, 5))
      
      # Generalized Pareto Distribution (GPD) for the tail of the case variable (vars[1])
      threshold <- quantile(subset[[1]], 0.90, na.rm = TRUE)
      ecdf_body <- ecdf(subset[[1]])
      excesses <- subset[[1]][subset[[1]] > threshold] - threshold
      gpd_model <- NULL
      
      # Fit GPD only if enough excesses exist
      if (length(excesses) > 20) {
        gpd_model <- fpot(subset[[1]], threshold = threshold, model = "gpd", std.err = FALSE)
      }
      
      # Store Copula information
      copulas_list[[paste0(com, "_State", state)]] <- list(
        copula = fit@copula,
        marginals = apply(subset, 2, ecdf),
        threshold = threshold,
        ecdf = ecdf_body
      )
      
      # Store GPD information
      gpd_fits[[paste0(com, "_State", state)]] <- gpd_model
    }
  }
}

# --- Simulation Procedure ---

# Define number of simulations
N_sim <- 200
simulations <- list()

for (com in comunas_objetivo) {
  data_com <- covid_data %>% filter(Commune == com)
  # Matrix to store N_sim case simulations for all dates in the commune
  sim_matrix <- matrix(NA, nrow = nrow(data_com), ncol = N_sim)
  
  for (i in 1:N_sim) {
    sim_cases <- numeric(nrow(data_com))
    
    # Loop over each day (row) in the commune's data
    for (j in seq_len(nrow(data_com))) {
      st <- data_com$Hidden_State[j] # Current Hidden State
      key <- paste0(com, "_State", st)
      cop_info <- copulas_list[[key]]
      gpd_info <- gpd_fits[[key]]
      
      if (!is.null(cop_info)) {
        cop_fit <- cop_info$copula
        threshold <- cop_info$threshold
        ecdf_body <- cop_info$ecdf
        
        # Sample multivariate data from the Copula
        u_sample <- rCopula(1, cop_fit)
        case_u <- u_sample[1] # Marginal pseudo-observation for the case variable
        
        # Inverse transformation using GPD for the tail or ECDF for the body
        if (!is.null(gpd_info) && case_u > ecdf_body(threshold)) {
          # GPD Tail Inverse Transformation
          p_exceed <- (case_u - ecdf_body(threshold)) / (1 - ecdf_body(threshold))
          gpd_params <- gpd_info$estimate
          sim_excess <- qgpd(p_exceed, loc = 0, scale = gpd_params["scale"], shape = gpd_params["shape"])
          inv_case <- threshold + sim_excess
        } else {
          # Empirical Body Inverse Transformation (using original data ECDF quantile)
          inv_case <- quantile(
            covid_data %>% filter(Commune == com, Hidden_State == st) %>% pull(vars[1]),
            probs = case_u, na.rm = TRUE
          )
        }
        sim_cases[j] <- inv_case
      } else {
        # Assign NA if copula model could not be fitted for this state/commune
        sim_cases[j] <- NA
      }
    }
    sim_matrix[, i] <- sim_cases
  }
  # Store simulation results for the commune
  simulations[[com]] <- data.frame(Date = data_com$Date, Commune = com, sim_matrix)
}

# --- Save and Visualize Results ---

# Bind all commune simulations into a single data frame
sim_df <- bind_rows(simulations)

# Save the simulation data
write.csv(sim_df, file.path(l, "simulated_cases_severity_weighted_v2.csv"), row.names = FALSE)

# Reshape simulation data for visualization (long format)
sim_long <- sim_df %>%
  pivot_longer(cols = starts_with("X"), names_to = "Simulation", values_to = "Sim_Cases") %>%
  filter(Commune %in% comunas_objetivo)
real_data <- covid_data %>% filter(Commune %in% comunas_objetivo)

# Plotting the simulations against observed data
p <- ggplot() +
  # Median line (blue)
  stat_summary(data = sim_long,
               aes(x = Date, y = Sim_Cases),
               fun = median,
               geom = "line", color = "blue", linetype = "solid",linewidth=0.8) +
  # Mean line (red)
  stat_summary(data = sim_long,
               aes(x = Date, y = Sim_Cases),
               fun = mean,
               geom = "line", color = "red", linetype = "solid",linewidth=0.8) +
  # Interquartile Range (IQR) ribbon (25th to 75th percentile)
  stat_summary(data = sim_long,
               aes(x = Date, y = Sim_Cases),
               fun.min = ~ quantile(., 0.25),
               fun.max = ~ quantile(., 0.75),
               geom = "ribbon", fill = "gray", alpha = 0.5) +
  # Observed data (black)
  geom_line(data = real_data,
            aes(x = Date, y = Gross_Daily_Cases_Mobile_Average_7_Days),
            color = "black", size = 0.9) +
  # Facet by commune
  facet_wrap(~Commune, scales = "free_y", ncol = 2) +
  labs(
    title = "Hybrid Copula-GPD Simulation vs Observed COVID-19 Cases",
    subtitle = "Severity-Weighted Hidden State Modeling",
    x = "Date", y = "Daily Cases (7-day MA)"
  ) + 
  theme_minimal()

print(p)
