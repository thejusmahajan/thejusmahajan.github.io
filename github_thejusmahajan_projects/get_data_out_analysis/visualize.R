# Load libraries
library(ggplot2)
library(dplyr)

# Define output directory
output_dir <- "results"
if (!dir.exists(output_dir)) {
  dir.create(output_dir)
}

# Load data
data_path <- "data/GDO_data_wide.csv"
df <- read.csv(data_path, stringsAsFactors = FALSE)

# Filter for Prostate Cancer, Single Years, and Total Incidence (All England, All Ages, All Stages, Male)
# We assume single years have 4 characters (e.g., "2013")

# Define filter values
target_region <- "All England"
target_age <- "All"
target_stage <- "All"
target_gender <- "Male"

plot_data <- df %>%
  filter(Cancer.Site == "Prostate",
         nchar(Year) == 4,
         Region == target_region,
         Age == target_age,
         Stage == target_stage,
         Gender == target_gender) %>%
  mutate(Year = as.numeric(Year),
         Rate = as.numeric(Age.Gender.Standardised.Incidence.Rate))

# Check if data is empty and debug
if (nrow(plot_data) == 0) {
  cat("Error: No data found after filtering.\n")
  stop("No data found for Prostate Cancer with specified filters.")
}

# Create the plot
p <- ggplot(plot_data, aes(x = Year, y = Rate)) +
  geom_line(color = "#005EB8", linewidth = 1.2) + # NHS Blue
  geom_point(color = "#005EB8", size = 3) +
  scale_x_continuous(breaks = unique(plot_data$Year)) +
  scale_y_continuous(limits = c(0, NA), n.breaks = 10) + # Start Y-axis at 0, more ticks
  labs(title = "Age-Standardized Incidence Rate of Prostate Cancer (England)",
       subtitle = "Data Source: NHS Get Data Out (All England, All Ages, All Stages)",
       x = "Diagnosis Year",
       y = "Age-Standardized Rate (per 100,000)",
       caption = paste0("Note: Data represents registered cases in England.\nData extracted on ", Sys.Date())) +
  
  # Annotation for 2018 Fry & Turnbull Effect
  annotate("segment", x = 2018, xend = 2018, 
           y = plot_data$Rate[plot_data$Year == 2018] + 20, 
           yend = plot_data$Rate[plot_data$Year == 2018] + 5, 
           arrow = arrow(length = unit(0.2, "cm")), color = "#333333") +
  annotate("text", x = 2018, y = plot_data$Rate[plot_data$Year == 2018] + 25, 
           label = "Fry & Turnbull Effect\n(Public Awareness)", 
           color = "#333333", vjust = 0, fontface = "bold", size = 3.5) +

  # Annotation for 2020 COVID-19 Impact
  annotate("segment", x = 2020, xend = 2020, 
           y = plot_data$Rate[plot_data$Year == 2020] - 20, 
           yend = plot_data$Rate[plot_data$Year == 2020] - 5, 
           arrow = arrow(length = unit(0.2, "cm")), color = "#333333") + 
  annotate("text", x = 2020, y = plot_data$Rate[plot_data$Year == 2020] - 25, 
           label = "COVID-19 Impact", 
           color = "#333333", vjust = 1, fontface = "bold", size = 3.5) +

  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    plot.subtitle = element_text(hjust = 0.5, color = "gray50"),
    panel.grid.minor = element_blank(),
    axis.text = element_text(color = "black")
  )

# Save the plot
output_file <- file.path(output_dir, "prostate_incidence_rate_trend.png")
ggsave(output_file, plot = p, width = 10, height = 6, dpi = 300)

cat("Plot saved to:", output_file, "\n")
