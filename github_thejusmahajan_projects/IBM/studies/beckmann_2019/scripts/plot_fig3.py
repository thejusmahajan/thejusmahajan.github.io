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

def plot_fig3_evolution(dist_data, env_data):
    """
    Figure 3: Temporal evolution of distribution with temperature jump.
    """
    n_steps = dist_data.shape[0]
    time = np.arange(n_steps) * (OUTPUT_DT / 86400.0) / 360.0 # Years
    y_bins = np.linspace(5.0, 25.0, 201)
    
    raw_matrix = dist_data.T.astype(float)
    smooth_matrix = gaussian_filter(raw_matrix, sigma=(1.0, 1.0))
    smooth_matrix[smooth_matrix < 0.1] = 0.1 # Avoid log(0)
    
    fig, ax = plt.subplots(figsize=(8, 6))
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
    
    # Fit Exponential to Mean Topt (for Adaptation Time)
    # T(t) = T_final - (T_final - T_initial) * exp(-(t - t_jump) / tau)
    # Jump happens at Year 1.
    mask = time > 1.0
    t_fit = time[mask] - 1.0 # Time since jump
    y_fit = mean_topt[mask]
    
    def exponential_recovery(t, tau):
        return 20.0 - (20.0 - 15.0) * np.exp(-t / tau)
    
    try:
        popt_exp, _ = curve_fit(exponential_recovery, t_fit, y_fit, p0=[1.25]) # Guess tau ~ 1.25 years (15 months)
        tau_years = popt_exp[0]
        tau_months = tau_years * 12.0
        print(f"Adaptation Time Scale (tau): {tau_years:.3f} years ({tau_months:.1f} months)")
        
        # Plot fit
        ax.plot(time[mask], exponential_recovery(t_fit, tau_years), 'g:', linewidth=2, label=f'Fit ($\\tau$={tau_months:.1f} mo)')
    except Exception as e:
        print(f"Could not fit exponential: {e}")

    ax.set_ylabel('Temperature [°C]')
    ax.set_xlabel('Time [Years]')
    ax.set_title('Evolution of Trait Distribution (Temp Jump 15->20°C)')
    ax.set_ylim(5, 25)
    ax.set_xlim(0, 10)
    ax.legend(loc='lower right')
    
    plt.tight_layout()
    plt.savefig(f"{PLOT_DIR}/fig3_evolution.png", dpi=300)
    plt.close()
    print("Generated fig3_evolution.png")

def plot_fig3_snapshot(dist_data, step_idx, label, fit_gaussian=False):
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
    
    filename = f"fig3_dist_{label.lower().replace(' ', '_').replace('(', '').replace(')', '').replace('.', '')}.png"
    plt.savefig(f"{PLOT_DIR}/{filename}", dpi=300)
    plt.close()
    print(f"Generated {filename}")

def main():
    print("Reading data...")
    data10 = read_fort10(f"{DATA_DIR}/fort.10")
    data12 = read_fort12(f"{DATA_DIR}/fort.12")
    
    if data10 is None or data12 is None:
        return

    # Plot Evolution (Figure 3)
    plot_fig3_evolution(data12, data10)
    
    # Plot Snapshots
    n_steps = data12.shape[0]
    
    # 1. Initial (t=0)
    plot_fig3_snapshot(data12, 0, "Initial (t=0)")
    
    # 2. Intermediate (1.5 Years)
    # 1.5 years = 1.5 * 360 = 540 days
    idx_mid = min(540, n_steps - 1)
    plot_fig3_snapshot(data12, idx_mid, "1.5 Years")
    
    # 3. Final (Steady State, Year 10)
    plot_fig3_snapshot(data12, -1, "Final (Year 10)", fit_gaussian=True)

if __name__ == "__main__":
    main()
