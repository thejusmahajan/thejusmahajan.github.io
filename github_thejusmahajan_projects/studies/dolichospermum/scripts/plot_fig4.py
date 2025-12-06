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

# Parameters
DT = 3600.0
OUTPUT_DT = 86400.0 # Daily output
NYEARS = 10

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

def plot_fig4_evolution(dist_data, env_data):
    """
    Figure 4: Temporal evolution of distribution with seasonal cycle.
    """
    n_steps = dist_data.shape[0]
    time = np.arange(n_steps) * (OUTPUT_DT / 86400.0) / 360.0 # Years
    y_bins = np.linspace(5.0, 25.0, 201)
    
    raw_matrix = dist_data.T.astype(float)
    smooth_matrix = gaussian_filter(raw_matrix, sigma=(1.0, 1.0))
    smooth_matrix[smooth_matrix < 0.1] = 0.1 # Avoid log(0)
    
    fig, ax = plt.subplots(figsize=(10, 6))
    cmap = plt.cm.get_cmap('YlOrRd')
    X, Y = np.meshgrid(time, y_bins)
    
    c = ax.pcolormesh(X, Y, smooth_matrix, cmap=cmap, shading='gouraud', 
                      norm=LogNorm(vmin=1.0, vmax=smooth_matrix.max()))
    
    # Add Contours (Beckmann Style)
    levels = [10, 30, 100, 300, 1000, 3000] 
    levels = [l for l in levels if l < smooth_matrix.max()]
    ax.contour(X, Y, smooth_matrix, levels=levels, colors='black', linewidths=0.5, alpha=0.5)
    
    # Overlay Environment Temp
    ax.plot(time, env_data[:n_steps, 0], color='black', linewidth=1.5, label='Env Temp')
    
    # Calculate and Overlay Mean T_opt
    mean_topt = np.zeros(n_steps)
    for i in range(n_steps):
        count = np.sum(dist_data[i, :])
        if count > 0:
            mean_topt[i] = np.sum(dist_data[i, :] * y_bins) / count
        else:
            mean_topt[i] = np.nan
    
    ax.plot(time, mean_topt, color='blue', linestyle='--', linewidth=1.5, label='Mean $T_{opt}$')
    
    ax.set_ylabel('Temperature [°C]')
    ax.set_xlabel('Time [Years]')
    ax.set_title('Evolution of Trait Distribution (Seasonal Cycle)')
    ax.set_ylim(5, 25)
    ax.set_xlim(0, 10)
    ax.legend(loc='lower right')
    
    plt.tight_layout()
    plt.savefig(f"{PLOT_DIR}/fig4_evolution.png", dpi=300)
    plt.close()
    print("Generated fig4_evolution.png")

def plot_fig4_snapshot(dist_data, step_idx, label, fit_gaussian=False):
    """
    Right Panels: Distribution at specific instances.
    """
    snapshot = dist_data[step_idx, :]
    x_axis = np.linspace(5.0, 25.0, 201)
    
    plt.figure(figsize=(6, 4))
    plt.bar(x_axis, snapshot, width=0.1, color='red', align='edge', alpha=0.7, label='Simulation')
    
    def gaussian(x, a, x0, sigma):
        return a * np.exp(-(x - x0)**2 / (2 * sigma**2))

    if fit_gaussian:
        # Fit Gaussian
        total_count = np.sum(snapshot)
        if total_count > 0:
            mean = np.sum(snapshot * x_axis) / total_count
            sigma = np.sqrt(np.sum(snapshot * (x_axis - mean)**2) / total_count)
            
            popt, pcov = curve_fit(gaussian, x_axis, snapshot, p0=[np.max(snapshot), mean, sigma])
            
            plt.plot(x_axis, gaussian(x_axis, *popt), 'k-', linewidth=2, label=f'Fit ($\sigma$={popt[2]:.3f}°C)')
            print(f"Snapshot {label}: Sigma = {popt[2]:.4f} deg C")
    
    plt.xlabel('Optimal Temperature ($T_{opt}$) [°C]')
    plt.ylabel('Count')
    plt.title(f'Distribution at {label}')
    plt.xlim(5, 25)
    plt.legend()
    plt.tight_layout()
    
    filename = f"fig4_dist_{label.lower().replace(' ', '_').replace('(', '').replace(')', '').replace('.', '')}.png"
    plt.savefig(f"{PLOT_DIR}/{filename}", dpi=300)
    plt.close()
    print(f"Generated {filename}")

def main():
    print("Reading data...")
    data10 = read_fort10(f"{DATA_DIR}/fort.10")
    data12 = read_fort12(f"{DATA_DIR}/fort.12")
    
    if data10 is None or data12 is None:
        return

    # Plot Evolution (Figure 4)
    plot_fig4_evolution(data12, data10)
    
    n_steps = data12.shape[0]

    # Plot Snapshots
    # 1. Initial (t=0)
    plot_fig4_snapshot(data12, 0, "Initial (t=0)")
    
    # 2. 42 Months (3.5 Years)
    # 3.5 * 360 = 1260 days
    idx_42mo = min(1260, n_steps - 1)
    plot_fig4_snapshot(data12, idx_42mo, "42 Months (3.5 Years)", fit_gaussian=True)
    
    # 3. 48 Months (4.0 Years)
    # 4.0 * 360 = 1440 days
    idx_48mo = min(1440, n_steps - 1)
    plot_fig4_snapshot(data12, idx_48mo, "48 Months (4.0 Years)", fit_gaussian=True)
    
    # 4. Summer/Winter (Year 9) - Keep these for reference
    idx_summer = min(3330, n_steps - 1)
    idx_winter = min(3510, n_steps - 1)
    
    plot_fig4_snapshot(data12, idx_summer, "Summer (Year 9)", fit_gaussian=True)
    plot_fig4_snapshot(data12, idx_winter, "Winter (Year 9)", fit_gaussian=True)

if __name__ == "__main__":
    main()
