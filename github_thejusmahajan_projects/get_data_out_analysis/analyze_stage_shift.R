# Load libraries
library(ggplot2)
library(dplyr)
library(tidyr)

# Define output directory
output_dir <- "results"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Load data
data_path <- "data/GDO_data_wide.csv"
df <- read.csv(data_path, stringsAsFactors = FALSE)

# Filter for Prostate Cancer, Single Years, Male, All England, All Ages
# We want to compare STAGES, so we filter Stage != "All"
target_region <- "All England"
target_age <- "All"
target_gender <- "Male"

# Filter data
plot_data <- df %>%
  filter(Cancer.Site == "Prostate",
         nchar(Year) == 4,
         Region == target_region,
         Age == target_age,
         Gender == target_gender,
         Stage != "All") %>%
  mutate(Year = as.numeric(Year),
         Incidence = as.numeric(Incidence))

# Check unique stages found
cat("Unique Stages found:\n")
print(unique(plot_data$Stage))

# Define Stage Categories of Interest
# Data uses: "Stage localised", "Stage locally advanced", "Stage metastatic", "Stage unknown"
# We INCLUDE "Stage unknown" to check for denominator bias.

target_stages <- c("Stage localised", "Stage locally advanced", "Stage metastatic", "Stage unknown")
stage_data <- plot_data %>%
  filter(Stage %in% target_stages)

# Reorder factor levels: Unknown at top (or bottom depending on preference, usually top for "missingness"), 
# then Localised -> Metastatic
stage_data$Stage <- factor(stage_data$Stage, levels = c("Stage unknown", "Stage metastatic", "Stage locally advanced", "Stage localised"))

# Calculate Proportions
stage_props <- stage_data %>%
  group_by(Year, Stage) %>%
  summarise(Count = sum(Incidence), .groups = "drop") %>%
  group_by(Year) %>%
  mutate(Proportion = Count / sum(Count))

# Create 100% Stacked Bar Chart (Completeness Check)
p1 <- ggplot(stage_props, aes(x = Year, y = Proportion, fill = Stage)) +
  geom_bar(stat = "identity", position = "fill", width = 0.7) +
  scale_y_continuous(labels = scales::percent) +
  scale_x_continuous(breaks = unique(stage_props$Year)) +
  scale_fill_manual(values = c("Stage localised" = "#BDD6EE",       # Light Blue
                               "Stage locally advanced" = "#5B9BD5", # Medium Blue
                               "Stage metastatic" = "#1F4E79",       # Dark Blue
                               "Stage unknown" = "#D9D9D9")) +       # Gray
  labs(title = "Stage Distribution of Prostate Cancer (England)",
       subtitle = "Proportion of New Diagnoses by Stage (Including Unknowns)",
       x = "Diagnosis Year",
       y = "Proportion of Cases",
       fill = "Stage",
       caption = paste0("Note: 'Stage unknown' included to assess data completeness.\nData extracted on ", Sys.Date())) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "gray50"),
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.text = element_text(color = "black")
  )

# Save the stacked bar chart
output_file1 <- file.path(output_dir, "prostate_stage_shift_with_unknowns.png")
ggsave(output_file1, plot = p1, width = 10, height = 6, dpi = 300)
cat("Stacked Bar Chart saved to:", output_file1, "\n")

# --- Metastatic Rate Analysis ---

# Filter for Metastatic Stage only to plot RATE (not proportion)
metastatic_data <- df %>%
  filter(Cancer.Site == "Prostate",
         nchar(Year) == 4,
         Region == target_region,
         Age == target_age,
         Gender == target_gender,
         Stage == "Stage metastatic") %>%
  mutate(Year = as.numeric(Year),
         Rate = as.numeric(Age.Gender.Standardised.Incidence.Rate))

# Create Line Chart for Metastatic Rate
p2 <- ggplot(metastatic_data, aes(x = Year, y = Rate)) +
  geom_line(color = "#1F4E79", linewidth = 1.2) + # Dark Blue
  geom_point(color = "#1F4E79", size = 3) +
  scale_x_continuous(breaks = unique(metastatic_data$Year)) +
  scale_y_continuous(limits = c(0, NA), n.breaks = 10) +
  labs(title = "Incidence Rate of Metastatic Prostate Cancer",
       subtitle = "Age-Standardized Rate (per 100,000)",
       x = "Diagnosis Year",
       y = "ASR (per 100,000)",
       caption = paste0("Note: Tracks absolute rate of advanced disease.\nData extracted on ", Sys.Date())) +
  
  # Annotation for 2020 COVID-19 Impact
  annotate("segment", x = 2020, xend = 2020, 
           y = metastatic_data$Rate[metastatic_data$Year == 2020] - 5, 
           yend = metastatic_data$Rate[metastatic_data$Year == 2020] - 1, 
           arrow = arrow(length = unit(0.2, "cm")), color = "#333333") + 
  annotate("text", x = 2020, y = metastatic_data$Rate[metastatic_data$Year == 2020] - 6, 
           label = "COVID-19 Impact", 
           color = "#333333", vjust = 1, fontface = "bold", size = 3.5) +

  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "gray50"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black")
  )

# Save the metastatic rate plot
output_file2 <- file.path(output_dir, "prostate_metastatic_rate.png")
ggsave(output_file2, plot = p2, width = 10, height = 6, dpi = 300)
cat("Metastatic Rate Plot saved to:", output_file2, "\n")
