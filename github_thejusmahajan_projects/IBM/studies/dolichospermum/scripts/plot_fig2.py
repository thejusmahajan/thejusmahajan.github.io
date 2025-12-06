import numpy as np
import matplotlib.pyplot as plt
from scipy.io import FortranFile
from scipy.ndimage import gaussian_filter
from matplotlib.colors import LogNorm
from scipy.optimize import curve_fit
import os

# Configuration
DATA_DIR = "output"
PLOT_DIR = "plots"
os.makedirs(PLOT_DIR, exist_ok=True)

# Parameters (Hardcoded to match run)
DT = 3600.0
OUTPUT_DT = 86400.0 # Daily output
NYEARS = 5

def read_fort10(filename):
    data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                record = f.read_record(dtype=np.float64)
                data.append(record)
            except Exception:
                break
        f.close()
    except FileNotFoundError:
        print(f"File {filename} not found.")
        return None
    return np.array(data)

def read_fort12(filename):
    dist_data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                record_bytes = f.read_record(dtype=np.byte)
                nbr_cls = np.frombuffer(record_bytes[:804], dtype=np.int32)
                dist_data.append(nbr_cls)
            except Exception:
                break
        f.close()
    except FileNotFoundError:
        print(f"File {filename} not found.")
        return None
    return np.array(dist_data)

def gaussian(x, a, x0, sigma):
    return a * np.exp(-(x - x0)**2 / (2 * sigma**2))

def plot_fig2_evolution(dist_data, env_data):
    """
    Left Panel: Temporal evolution of distribution.
    """
    n_steps = dist_data.shape[0]
    time = np.arange(n_steps) * (OUTPUT_DT / 86400.0) / 360.0 # Years
    y_bins = np.linspace(5.0, 25.0, 201)
    
    raw_matrix = dist_data.T.astype(float)
    smooth_matrix = gaussian_filter(raw_matrix, sigma=(1.0, 1.0))
    smooth_matrix[smooth_matrix < 0.1] = 0.1 # Avoid log(0)
    
    fig, ax = plt.subplots(figsize=(6, 8))
    cmap = plt.cm.get_cmap('YlOrRd')
    X, Y = np.meshgrid(time, y_bins)
    
    c = ax.pcolormesh(X, Y, smooth_matrix, cmap=cmap, shading='gouraud', 
                      norm=LogNorm(vmin=1.0, vmax=smooth_matrix.max()))
    
    # Add Contours (Beckmann Style)
    # We use levels that pick up the density features
    levels = [10, 30, 100, 300, 1000, 3000] 
    # Filter levels to be within data range
    levels = [l for l in levels if l < smooth_matrix.max()]
    
    ax.contour(X, Y, smooth_matrix, levels=levels, colors='black', linewidths=0.5, alpha=0.5)
    
    # Overlay Environment Temp
    ax.plot(time, env_data[:n_steps, 0], color='black', linewidth=1.5)
    
    ax.set_ylabel('Optimal Temperature ($T_{opt}$) [°C]')
    ax.set_xlabel('Time [Years]')
    ax.set_title('Evolution of Trait Distribution')
    ax.set_ylim(5, 25)
    ax.set_xlim(0, 5)
    
    plt.tight_layout()
    plt.savefig(f"{PLOT_DIR}/fig2_evolution.png", dpi=300)
    plt.close()
    print("Generated fig2_evolution.png")

def plot_fig2_snapshot(dist_data, step_idx, label, fit_gaussian=False):
    """
    Right Panels: Distribution at specific instances.
    """
    snapshot = dist_data[step_idx, :]
    x_axis = np.linspace(5.0, 25.0, 201)
    
    plt.figure(figsize=(6, 4))
    plt.bar(x_axis, snapshot, width=0.1, color='red', align='edge', alpha=0.7, label='Simulation')
    
    if fit_gaussian:
        # Fit Gaussian
        total_count = np.sum(snapshot)
        mean = np.sum(snapshot * x_axis) / total_count
        sigma = np.sqrt(np.sum(snapshot * (x_axis - mean)**2) / total_count)
        
        # Refine fit using curve_fit for better accuracy if needed, but moment matching is robust
        popt, pcov = curve_fit(gaussian, x_axis, snapshot, p0=[np.max(snapshot), mean, sigma])
        
        plt.plot(x_axis, gaussian(x_axis, *popt), 'k-', linewidth=2, label=f'Fit ($\sigma$={popt[2]:.3f}°C)')
        print(f"Snapshot {label}: Sigma = {popt[2]:.4f} deg C")
    
    plt.xlabel('Optimal Temperature ($T_{opt}$) [°C]')
    plt.ylabel('Count')
    plt.title(f'Distribution at {label}')
    plt.xlim(5, 25)
    plt.legend()
    plt.tight_layout()
    
    filename = f"fig2_dist_{label.lower().replace(' ', '_')}.png"
    plt.savefig(f"{PLOT_DIR}/{filename}", dpi=300)
    plt.close()
    print(f"Generated {filename}")

def main():
    print("Reading data...")
    data10 = read_fort10(f"{DATA_DIR}/fort.10")
    data12 = read_fort12(f"{DATA_DIR}/fort.12")
    
    if data10 is None or data12 is None:
        return

    # Plot Evolution (Left Panel)
    plot_fig2_evolution(data12, data10)
    
    # Plot Snapshots (Right Panels)
    n_steps = data12.shape[0]
    
    # 1. Initial (t=0)
    plot_fig2_snapshot(data12, 0, "Initial (t=0)")
    
    # 2. Intermediate (e.g., Year 1)
    # 1 year = 360 days. Output is daily.
    idx_mid = min(360, n_steps - 1)
    plot_fig2_snapshot(data12, idx_mid, "Year 1")
    
    # 3. Final (Steady State, Year 5)
    plot_fig2_snapshot(data12, -1, "Final (Year 5)", fit_gaussian=True)

if __name__ == "__main__":
    main()
