import numpy as np
import matplotlib.pyplot as plt
from scipy.io import FortranFile
import os
import sys

# Configuration
PLOT_DIR = "plots"
os.makedirs(PLOT_DIR, exist_ok=True)

# Parameters
OUTPUT_DT = 86400.0 * 10.0 # Output every 10 days (based on wcm.F90 modification)
# Wait, did I modify wcm.F90 to output every 10 days?
# Let's check wcm.F90 line 320: IF (mod(iday, 10) .eq. 0) THEN WRITE(6, ...)
# But WRITE(11) is in line 351: IF(dmod(time+0.5d0*secday,secday).eq.0.d0) THEN ... WRITE(11)
# So fort.11 is written DAILY.

OUTPUT_DT = 86400.0 # Daily output

def read_fort11(filename):
    data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                # WRITE(11) aorg(lnew),detr(lnew),phyt(lnew)
                record = f.read_record(dtype=np.float64)
                data.append(record)
            except Exception:
                break
        f.close()
    except FileNotFoundError:
        print(f"File {filename} not found.")
        return None
    return np.array(data)

def plot_hindcast(evolving_file, static_file):
    print("Reading Evolving Scenario...")
    data_evol = read_fort11(evolving_file)
    
    print("Reading Static Scenario...")
    data_stat = read_fort11(static_file)
    
    if data_evol is None or data_stat is None:
        return

    # Time axis
    n_steps = min(data_evol.shape[0], data_stat.shape[0])
    time = np.arange(n_steps) * (OUTPUT_DT / 86400.0) / 360.0 # Years
    
    # Extract Phytoplankton Biomass (Column 2, 0-indexed)
    # WRITE(11) aorg, detr, phyt
    # So phyt is index 2.
    phyt_evol = data_evol[:n_steps, 2]
    phyt_stat = data_stat[:n_steps, 2]
    
    # Apply rolling mean to smooth seasonal cycle for clearer trend visualization?
    # Or just plot the envelope?
    # Let's plot the raw data first, maybe with transparency.
    
    fig, ax = plt.subplots(figsize=(12, 6))
    
    ax.plot(time, phyt_evol, 'r-', linewidth=0.5, alpha=0.8, label='Scenario A: Evolving')
    ax.plot(time, phyt_stat, 'b-', linewidth=0.5, alpha=0.6, label='Scenario B: Static')
    
    # Add trend lines (annual means)
    # Reshape to (Years, 360) assuming 360 days/year
    # Truncate to full years
    n_years = n_steps // 360
    if n_years > 0:
        phyt_evol_yr = phyt_evol[:n_years*360].reshape(n_years, 360).mean(axis=1)
        phyt_stat_yr = phyt_stat[:n_years*360].reshape(n_years, 360).mean(axis=1)
        time_yr = np.arange(n_years) + 0.5
        
        ax.plot(time_yr, phyt_evol_yr, 'r-', linewidth=2.5, label='Evolving (Annual Mean)')
        ax.plot(time_yr, phyt_stat_yr, 'b-', linewidth=2.5, label='Static (Annual Mean)')
    
    ax.set_ylabel('Phytoplankton Biomass [mmol N m$^{-3}$]')
    ax.set_xlabel('Time [Years]')
    ax.set_title('Climate Change Hindcast: Evolving vs. Static Response')
    ax.legend()
    ax.grid(True, alpha=0.3)
    ax.set_xlim(0, 100)
    
    plt.tight_layout()
    plt.savefig(f"{PLOT_DIR}/hindcast_biomass_overview.png", dpi=300)
    plt.close()
    print("Generated hindcast_biomass_overview.png")

    # Function to plot zoomed segments
    def plot_segment(start_year, end_year, suffix):
        start_idx = int(start_year * 360 / (OUTPUT_DT / 86400.0))
        end_idx = int(end_year * 360 / (OUTPUT_DT / 86400.0))
        
        # Ensure indices are within bounds
        start_idx = max(0, start_idx)
        end_idx = min(n_steps, end_idx)
        
        if start_idx >= end_idx:
            return

        t_seg = time[start_idx:end_idx]
        p_evol_seg = phyt_evol[start_idx:end_idx]
        p_stat_seg = phyt_stat[start_idx:end_idx]
        
        fig, ax = plt.subplots(figsize=(12, 6))
        ax.plot(t_seg, p_evol_seg, 'r-', linewidth=1.0, alpha=0.9, label='Scenario A: Evolving')
        ax.plot(t_seg, p_stat_seg, 'b-', linewidth=1.0, alpha=0.7, label='Scenario B: Static')
        
        ax.set_ylabel('Phytoplankton Biomass [mmol N m$^{-3}$]')
        ax.set_xlabel('Time [Years]')
        ax.set_title(f'Climate Change Hindcast: Years {start_year}-{end_year}')
        ax.legend()
        ax.grid(True, alpha=0.3)
        ax.set_xlim(start_year, end_year)
        
        filename = f"hindcast_biomass_{suffix}.png"
        plt.savefig(f"{PLOT_DIR}/{filename}", dpi=300)
        plt.close()
        print(f"Generated {filename}")

    # Generate Zoomed Plots (5-Year Segments)
    plot_segment(0, 5, "0_5")
    plot_segment(95, 100, "95_100")

    # Calculate Statistics for Table
    def get_stats(data, start_yr, end_yr):
        start_idx = int(start_yr * 360)
        end_idx = int(end_yr * 360)
        segment = data[start_idx:end_idx]
        return np.mean(segment), np.max(segment)

    # Early Period (0-5y)
    mean_evol_early, max_evol_early = get_stats(phyt_evol, 0, 5)
    mean_stat_early, max_stat_early = get_stats(phyt_stat, 0, 5)

    # Late Period (95-100y)
    mean_evol_late, max_evol_late = get_stats(phyt_evol, 95, 100)
    mean_stat_late, max_stat_late = get_stats(phyt_stat, 95, 100)

    print("\n--- Results Table Data ---")
    print(f"Early (0-5y) Evolving: Mean={mean_evol_early:.3f}, Peak={max_evol_early:.3f}")
    print(f"Early (0-5y) Static:   Mean={mean_stat_early:.3f}, Peak={max_stat_early:.3f}")
    print(f"Late (95-100y) Evolving: Mean={mean_evol_late:.3f}, Peak={max_evol_late:.3f}")
    print(f"Late (95-100y) Static:   Mean={mean_stat_late:.3f}, Peak={max_stat_late:.3f}")
    print("--------------------------\n")

if __name__ == "__main__":
    plot_hindcast("output/fort.11.evolving", "output/fort.11.static")
