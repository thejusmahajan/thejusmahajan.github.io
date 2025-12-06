# Lagrangian Agent-Based Model of Phytoplankton Trait Evolution

## Overview
This repository contains a **Lagrangian Agent-Based Model (ABM)**, also known as an Individual-Based Model (IBM), designed to simulate the adaptive dynamics of phytoplankton communities in a 0D/1D water column. The model is based on the framework described by **Beckmann et al. (2019)**, focusing on the evolution of functional traits—specifically **Optimal Temperature ($T_{opt}$)**—in response to environmental forcing.

## Scientific Framework

### Model Architecture
- **Lagrangian Super-Individuals**: To computationally handle the vast number of phytoplankton cells, the model utilizes the concept of "super-individuals". Each agent represents a cohort of identical cells that share the same physiological state and functional traits.
- **NPZD Dynamics**: The biological interaction follows a Nutrient-Phytoplankton-Zooplankton-Detritus (NPZD) scheme.
    - **Nutrients (N)**: Dissolved inorganic nitrogen.
    - **Phytoplankton (P)**: Modeled explicitly as agents.
    - **Zooplankton (Z)**: Represented as a closure term (grazing mortality).
    - **Detritus (D)**: Remineralizing organic matter.

### Adaptive Dynamics
The core feature of this model is the simulation of trait evolution.
- **Trait Space**: Agents are characterized by their optimal temperature for growth ($T_{opt}$).
- **Selection**: Environmental temperature acts as a selection pressure. Agents with $T_{opt}$ close to the ambient temperature have higher growth rates ($\mu$).
- **Mutation**: Upon cell division, daughter agents inherit the parent's trait with a small random mutation, allowing the population to drift through trait space and adapt to seasonal changes.

### Computational Implementation
- **Parallelization**: The computationally intensive particle loops (growth, mortality, biomass summation) are parallelized using **OpenMP**, allowing for efficient simulation of large populations ($10^5$ agents).
- **Dynamic Memory**: The model uses Fortran allocatable arrays to dynamically manage the agent population size.

## Directory Structure
- **`src/`**: Fortran source code.
    - `wcm.F90`: Main program and time-stepping loop.
    - `phyt_ibm.F90`: Biological subroutines (growth, mortality, division).
    - `wcm_arrays.f90`: Global arrays and parameter definitions.
- **`scripts/`**: Execution and visualization scripts.
    - `run_model.sh`: Compilation and execution script (gfortran + OpenMP).
    - `plot_results.py`: Python visualization suite using `scipy.ndimage` for Gaussian smoothing.
- **`output/`**: Binary model output (`fort.*`).
- **`plots/`**: Visualization output.

## Running the Model
The model is compiled and executed via the provided shell script, which handles OpenMP flags and environment variables.

```bash
cd scripts
./run_model.sh
```

## Visualization
The visualization workflow produces publication-quality plots, including **Hovmöller diagrams** of trait distribution.

```bash
cd scripts
python3 plot_results.py
```

### Key Outputs
- **`beckmann_elegant.png`**: A smoothed heatmap showing the evolution of the trait distribution ($T_{opt}$) over time, overlaid with environmental temperature. This visualization applies **Gaussian smoothing** to the discrete agent data to approximate the continuous probability density function of the trait, matching the aesthetic of Beckmann et al. (2019).
- **`wcm_plots_ecosystem.png`**: Time series of state variables (N, P, D) demonstrating bloom dynamics.

## References
Beckmann, A., Schaum, C-E., & Hense, I. (2019). Phytoplankton adaptation in ecosystem models. *Journal of Theoretical Biology*, 468, 60-71. https://doi.org/10.1016/j.jtbi.2019.01.041
