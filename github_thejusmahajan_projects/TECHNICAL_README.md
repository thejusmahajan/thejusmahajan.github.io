# NPZD Individual-Based Model (IBM) Technical Report

## 1. Overview
This project implements a **Nutrient-Phytoplankton-Zooplankton-Detritus (NPZD)** model to simulate the ecosystem dynamics of a water column. A key feature of this implementation is the use of an **Individual-Based Model (IBM)** for the phytoplankton component. Instead of modeling phytoplankton as a single continuous concentration, it is modeled as a collection of distinct agents (cells) with individual traits.

### Key Features
- **Lagrangian Agents**: Phytoplankton are modeled as individual particles.
- **Trait-Based Approach**: Each agent has a specific **optimal temperature** for growth.
- **Evolutionary Dynamics**: Agents reproduce (divide) and pass on traits with slight **mutations**, allowing the population to adapt to changing environmental conditions (seasonal temperature cycles).

## 2. Project Structure
The project is organized into the following directory structure to separate source code, scripts, and artifacts:

```
.
├── src/                # Source code (Fortran 90)
│   ├── wcm.F90         # Main program (Water Column Model)
│   ├── phyt_ibm.F90    # Phytoplankton IBM module
│   ├── wcm_arrays.f90  # Shared data structures and arrays
│   └── subs.f          # Auxiliary subroutines
├── scripts/            # Execution and plotting scripts
│   ├── run_model.sh    # Script to compile and run the simulation
│   └── plot_results.ncl# NCL script for data visualization
├── output/             # Simulation output files (fort.*)
├── plots/              # Generated plots and animations
└── archive/            # Archived/Legacy files
```

## 3. Model Implementation Details

### 3.1 Main Simulation Loop (`wcm.F90`)
The main program initializes the state variables and iterates through time. It handles physical forcing such as sunlight and temperature variations.

```fortran
! wcm.F90: Main time loop
DO 1000 it=1,itmax
   ! Advance time
   time=time+dt
   
   ! Calculate physical forcing (Irradiance, Temperature)
   CALL sunlight(time,pi,solrad)
   
   ! ... (Nutrient dynamics) ...

   ! Call the IBM subroutine for phytoplankton dynamics
   #ifdef PHYT_IBM
   CALL phyt_ibm
   #endif
   
   ! ... (Output writing) ...
1000 CONTINUE
```

### 3.2 Phytoplankton Agents (`phyt_ibm.F90`)
The core logic for the agents is contained in `phyt_ibm.F90`.

#### Growth
Growth is determined by nutrient availability (`aorg`), light (`swrad`), and the match between the current water temperature (`temp`) and the agent's optimal temperature (`phyopt`).

```fortran
! phyt_ibm.F90: Cell growth
DO i=1,M2max
  IF(iliv(i).eq.1) THEN
      ! Temperature limitation function (Gaussian around optimal temp)
      templim=exp(-((temp-phyopt(i))/tslope)**2)
      
      ! Growth rate calculation
      growth=1.0d0/secday*biopercell*cpa &
            *aorgpos/(0.15d0+aorgpos) & ! Nutrient limitation (Michaelis-Menten)
            *templim                    ! Temperature limitation
            
      phybio(i)=phybio(i)+dt*growth
  ENDIF
ENDDO
```

#### Cell Division and Mutation
When a cell reaches a critical biomass (`cpa * biopercell`), it divides. The daughter cell inherits the parent's optimal temperature with a small random mutation, driving the evolutionary adaptation.

```fortran
! phyt_ibm.F90: Cell division
IF(phybio(i).ge.cpa*biopercell) THEN
    ! Parent cell splits
    phybio(i)=0.5d0*phybio(i)
    
    ! Create new daughter cell (agent)
    phybio(inew)=phybio(i)
    iliv(inew)=1
    
    ! Mutation: Daughter inherits parent's optimal temp +/- random variation
    phyopt(inew)=rand_normal(phyopt(i),0.1d0)
ENDIF
```

## 4. Workflow and Compilation

### Prerequisites
- **Compiler**: `gfortran`
- **Preprocessor**: `cpp`
- **Visualization**: `NCL` (NCAR Command Language), `ImageMagick` (for GIF creation)

### Step 1: Compilation & Execution
The `scripts/run_model.sh` script handles the entire build and run process. It preprocesses the `.F90` files to handle macros (like `#ifdef PHYT_IBM`), compiles the modules, and links the executable.

**Code Snippet: `run_model.sh`**
```bash
#!/bin/bash
# ... (Directory setup) ...

# 1. Preprocess
cpp -P "$SRC_DIR/wcm.F90" > wcm.f90
cpp -P "$SRC_DIR/phyt_ibm.F90" > phyt_ibm.f90

# 2. Compile
gfortran -c "$SRC_DIR/wcm_arrays.f90"
gfortran -fmax-stack-var-size=32768 -w -O3 -o wcm.x wcm.f90 phyt_ibm.f90 wcm_arrays.o

# 3. Run
./wcm.x
```

To run the model:
```bash
cd scripts
./run_model.sh
```
This generates binary output files (`fort.10`, `fort.11`, `fort.12`) in the `output/` directory.

## 5. Visualization

We use **Python** (Matplotlib) to process the binary output files and generate high-quality plots. The script `scripts/plot_results.py` reads the unformatted Fortran data and produces time-series plots and an animation.

### Step 2: Generating Plots
The Python script uses `scipy.io.FortranFile` to read the binary data structure.

**Code Snippet: `plot_results.py` (Reading Data)**
```python
from scipy.io import FortranFile
# Read binary data from fort.10 (Temperature, Irradiance)
f = FortranFile(filename, 'r')
record = f.read_record(dtype=np.float64)
# record[0] is temp, record[1] is swrad
```

To generate the plots:
```bash
cd scripts
python3 plot_results.py
```

### Step 3: Creating the Animation
The Python script generates a sequence of PNG files (`anim_frame_*.png`) showing the distribution of phytoplankton optimal temperature traits over time. It then uses `ImageMagick` (via `subprocess`) to stitch these into a GIF.

## 6. Results

The workflow produces the following artifacts in the `plots/` directory:

1.  **`wcm_plots_irradiance.png`**: **Irradiance** - Shows the seasonal cycle of sunlight.
2.  **`wcm_plots_temperature.png`**: **Temperature** - Shows the seasonal water temperature cycle.
3.  **`wcm_plots_ecosystem.png`**: **Ecosystem Dynamics** - Time series of Nutrients, Phytoplankton Biomass, and Detritus.
4.  **`animation.gif`**: **Trait Evolution** - An animation showing how the distribution of "optimal temperature" traits in the phytoplankton population shifts in response to the changing water temperature.

---
*Report generated by Antigravity Assistant.*
