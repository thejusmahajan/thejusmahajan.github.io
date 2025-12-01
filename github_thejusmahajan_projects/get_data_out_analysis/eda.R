# Load necessary libraries
# Check if tidyverse is available, otherwise use base R
if (!require("tidyverse", quietly = TRUE)) {
  warning("tidyverse not found, using base R for some operations.")
}

# Define data path
data_path <- "data/GDO_data_wide.csv"

# Load data
cat("Loading data from:", data_path, "\n")
df <- read.csv(data_path, stringsAsFactors = FALSE)

# Find columns with Site, Group, or Cancer
cat("\n--- Columns with Site/Group/Cancer ---\n")
print(grep("Site|Group|Cancer", colnames(df), value = TRUE))

# Check for specific columns
cat("\n--- Unique Cancer Sites ---\n")
if("Cancer.Site" %in% colnames(df)) {
    print(unique(df$Cancer.Site))
} else {
    cat("Could not find Cancer.Site column.\n")
}

cat("\n--- Diagnosis Years ---\n")
if("Diagnosis_Year" %in% colnames(df)) {
    print(unique(df$Diagnosis_Year))
} else if ("Year" %in% colnames(df)) {
    print(unique(df$Year))
}

cat("\n--- Statistics Available ---\n")
# Check for columns related to Incidence, Survival, Treatment
print(grep("Incidence|Survival|Treatment", colnames(df), value = TRUE))
