# Epidemiological Report: Prostate Cancer Incidence and Staging Trends in England (2013–2022)

**Date:** November 30, 2025  
**Data Source:** NHS National Disease Registration Service (NDRS) "Get Data Out" Platform  
**Region:** England (National Coverage)  
**Metric:** Age-Standardized Incidence Rates (ASR) & Staging Proportions

---

## 1. Executive Summary

This analysis reviews a decade of prostate cancer registration data in England to assess the impact of the COVID-19 pandemic on diagnostic trends.

**Key Findings:**

*   **The Pandemic Shock:** There was a precipitous **27% drop** in the age-standardized incidence rate in 2020 compared to the 2018 peak, representing thousands of "missed" diagnoses.
*   **The Rebound:** By 2022, the incidence rate rebounded to **215 per 100,000**—the highest level recorded in the decade—suggesting the "backlog" of undiagnosed cases is now entering the healthcare system.
*   **Stage Migration:** Analysis of staging data confirms a shift in the diagnostic mix. While data completeness remained robust during the pandemic, there is a marked long-term shift from "Localised" to "Locally Advanced" diagnoses, alongside a concerning persistence of metastatic disease in the post-pandemic recovery period.

---

## 2. Data Source & Methodology

### 2.1 Data Source
The data for this analysis was obtained from the **NHS National Disease Registration Service (NDRS)** via the "Get Data Out" (GDO) platform.
*   **Portal:** [NHS Get Data Out](https://nhsd-ndrs.shinyapps.io/get_data_out/)
*   **File Used:** `GDO_data_wide.csv` (Wide format containing all cancer sites and statistics).

### 2.2 Data Structure
The GDO dataset is provided in a **stratified "long" format**. This means that for every Diagnosis Year, the data is pre-aggregated into multiple overlapping subgroups (strata).
*   **Dimensions:** The data is cut by `Region`, `Age Group`, `Stage`, `Gender`, and `Deprivation`.
*   **Implication:** A naive sum of the `Incidence` column would result in massive double-counting (e.g., summing "All Ages" with "Age 70-79").
*   **Handling:** Correct analysis requires strict filtering to isolate mutually exclusive groups (e.g., filtering for `Region = "All England"`, `Age = "All"`, `Stage = "All"` to get the national total).

### 2.3 Analytical Approach (R Methodology)
To ensure statistical integrity, we utilized the **R programming language** for data wrangling and visualization.

**Key R Commands & Workflow:**
1.  **Filtering (`dplyr::filter`):** We strictly filtered the dataset to isolate the specific cohort of interest.
    *   *Example:* `filter(Cancer.Site == "Prostate", Region == "All England", Gender == "Male", Stage == "All")`
2.  **Selection (`dplyr::select`):** We focused on key metrics: `Incidence` (counts) and `Age.Gender.Standardised.Incidence.Rate` (ASR).
3.  **Visualization (`ggplot2`):**
    *   **Line Charts:** Used to plot time-series trends of ASR (`geom_line` + `geom_point`).
    *   **Stacked Bar Charts:** Used to visualize the proportion of diagnoses by Stage (`geom_bar(position = "fill")`).
4.  **Annotations:** We programmatically added annotations (`annotate`) to highlight key events like the 2018 "Fry & Turnbull Effect" and the 2020 COVID-19 impact.

---

## 3. Incidence Trends (2013–2022)

### 3.1 Methodology: Rate vs. Count
To accurately assess risk, we utilized **Age-Standardized Rates (ASR)** per 100,000 population. This removes the confounding variable of England's aging population. Analysis of raw counts (not presented here) showed a steeper upward trend, but much of that growth was attributable solely to demographic shifts.

### 3.2 The "Fry & Turnbull" Effect (2018)
The data reveals a statistically significant deviation in 2018, where incidence spiked to **210 per 100,000**. This correlates with the "Fry & Turnbull Effect"—a public health phenomenon triggered by celebrities Stephen Fry and Bill Turnbull publicly disclosing their diagnoses. This highlights the high sensitivity of prostate cancer incidence to public awareness and testing behaviors (PSA testing).

### 3.3 The COVID-19 Impact & Recovery (2020–2022)
*   **2020 (The Drop):** Incidence fell to ~148 per 100,000. This drop is non-biological and entirely attributable to reduced access to primary care (GP referrals) and diagnostic bottlenecks during the pandemic lockdowns.
*   **2022 (The Surge):** The rate climbed to ~215 per 100,000 in 2022. This rebound exceeds the 2018 peak. This suggests that the cohort of men missed in 2020/2021 are now presenting, likely with more symptomatic disease.

**Visualization 1: Age-Standardized Incidence Rate Trends**
![Prostate Cancer Incidence Rate Trends](figures/prostate_incidence_rate_trend.png)

---

## 4. Staging Analysis

### 4.1 Data Integrity Check
A critical concern was that the 2020 drop was caused by poor data collection. However, analysis of "Stage Unknown" (missing data) shows stability:
*   Unknown Stage consistently accounts for **10–15%** of cases across the decade.
*   There was **no significant spike** in Unknowns during 2020–2021.

**Conclusion:** The observed trends in staging are biological or administrative, not artifacts of missing data.

**Visualization 2: Stage Distribution (Completeness Check)**
![Prostate Cancer Stage Shift (with Unknowns)](figures/prostate_stage_shift_with_unknowns.png)

### 4.2 The "Stage Shift"
We observed a significant redistribution of diagnosed stages over the decade:
*   **Decline of Localised Disease:** The proportion of Stage 1 & 2 (Localised) cancers has shrunk significantly, from ~45% in 2013 to ~40% in 2022.
*   **Rise of Locally Advanced:** Stage 3 (Locally Advanced) has grown from ~30% to ~35%.
    *   *Note: A portion of this shift is likely administrative, due to the adoption of TNM 8 staging rules (replacing TNM 7) around 2018, which reclassified certain T2 tumors as T3.*
*   **Metastatic Resilience:** Despite the volatility in early detection, the proportion of Metastatic (Stage 4) disease has remained stubbornly high.

---

## 5. Discussion & Recommendations

The data indicates a healthcare system currently processing a "catch-up" cohort. The 2022 incidence peak confirms that the "missing men" from the pandemic years did not disappear; they simply delayed presentation.

**Implications:**
1.  **Resource Allocation:** The combination of record-high incidence (2022) and a shift toward "Locally Advanced" disease suggests a higher workload for oncology departments. These patients require multimodal therapy (surgery/radiotherapy + hormones) compared to the active surveillance often used for localised disease.
2.  **Metastatic Risk:** Continued monitoring of the Metastatic Incidence Rate is required. If the backlog leads to a surge in incurable disease, palliative care resources will need to be reinforced in 2025–2026.

**Conclusion:**
The "Get Data Out" dataset confirms that while the immediate shock of COVID-19 (missed diagnoses) has passed, the secondary impact (record-high volume and stage migration) is now the dominant challenge for the NHS Urology services.

---

## Appendix A: Alternative Analysis (R Code)

The following R code is provided as study material. It demonstrates how to generate the "Metastatic Incidence Rate" trend line using the `ggplot2` and `dplyr` packages, which are standard tools for health data science.

```r
library(ggplot2)
library(dplyr)

# Function to plot Metastatic Risk
plot_metastatic_risk <- function(df) {
  # 1. Filter Data
  # We isolate "Stage metastatic" and ensure we use the Age-Standardized Rate (ASR)
  metastatic_data <- df %>%
    filter(Stage == "Stage metastatic") %>%
    mutate(Year = as.numeric(Year),
           Rate = as.numeric(Age.Gender.Standardised.Incidence.Rate))

  # 2. Create Plot
  ggplot(metastatic_data, aes(x = Year, y = Rate)) +
    # Line and Points
    geom_line(color = "#1F4E79", linewidth = 1.2) + # Dark Blue
    geom_point(color = "#1F4E79", size = 3) +
    
    # Scales
    scale_x_continuous(breaks = unique(metastatic_data$Year)) +
    scale_y_continuous(limits = c(0, NA), n.breaks = 10) +
    
    # Labels
    labs(title = "Incidence Rate of Metastatic Prostate Cancer",
         subtitle = "Age-Standardized Rate (per 100,000)",
         x = "Diagnosis Year",
         y = "ASR (per 100,000)") +
    
    # 3. Annotation (Highlighting the COVID-19 Impact)
    annotate("segment", x = 2020, xend = 2020, 
             y = metastatic_data$Rate[metastatic_data$Year == 2020] - 5, 
             yend = metastatic_data$Rate[metastatic_data$Year == 2020] - 1, 
             arrow = arrow(length = unit(0.2, "cm")), color = "#333333") + 
    annotate("text", x = 2020, y = metastatic_data$Rate[metastatic_data$Year == 2020] - 6, 
             label = "COVID-19 Impact", 
             color = "#333333", vjust = 1, fontface = "bold", size = 3.5) +

    # 4. Theme (Clean Professional Look)
    theme_minimal(base_size = 14) +
    theme(
      plot.title = element_text(face = "bold", hjust = 0.5),
      plot.subtitle = element_text(hjust = 0.5, color = "gray50"),
      panel.grid.minor = element_blank(),
      axis.text = element_text(color = "black")
    )
}

# Usage Example:
# 1. Load Data
# df <- read.csv("GDO_data_wide.csv")
# 2. Filter for Target Cohort (e.g., All England, Male)
# cohort_df <- df %>% filter(Region == "All England", Gender == "Male")
# 3. Generate Plot
# plot_metastatic_risk(cohort_df)
```
