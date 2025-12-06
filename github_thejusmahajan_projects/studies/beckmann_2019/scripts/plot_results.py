import numpy as np
import matplotlib.pyplot as plt
from scipy.io import FortranFile
from matplotlib.colors import LogNorm
import os
import subprocess

# Configuration
DATA_DIR = "../output"
PLOT_DIR = "../plots"
PARAM_FILE = "../parameters.nml"
os.makedirs(PLOT_DIR, exist_ok=True)

def read_parameters():
    """Reads dt from parameters.nml"""
    params = {'dt': 3600.0} # Default
    try:
        with open(PARAM_FILE, 'r') as f:
            for line in f:
                if 'dt' in line and '=' in line:
                    try:
                        # Extract value after =
                        val_str = line.split('=')[1].strip()
                        # Remove any comments
                        val_str = val_str.split('!')[0].strip()
                        params['dt'] = float(val_str)
                    except ValueError:
                        pass
    except FileNotFoundError:
        print(f"Warning: {PARAM_FILE} not found. Using default dt=3600.0")
    return params

PARAMS = read_parameters()
DT = PARAMS['dt']

def read_fort10(filename):
    """Reads Temperature and Irradiance from fort.10"""
    data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                # WRITE(10) temp, swrad
                # 2 doubles
                record = f.read_record(dtype=np.float64)
                data.append(record)
            except Exception:
                break
        f.close()
    except FileNotFoundError:
        print(f"File {filename} not found.")
        return None
    return np.array(data)

def read_fort11(filename):
    """Reads Nutrients, Detritus, Phytoplankton from fort.11"""
    data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                # WRITE(11) aorg, detr, phyt
                # 3 doubles
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
    """Reads Size Distribution from fort.12"""
    dist_data = []
    try:
        f = FortranFile(filename, 'r')
        while True:
            try:
                # WRITE(12) nbr_cls, growthmean0, growthmean
                # nbr_cls is 201 integers (0:200)
                # growthmean0, growthmean are doubles
                # Total bytes: 201*4 + 2*8 = 804 + 16 = 820 bytes
                
                # Read raw bytes
                record_bytes = f.read_record(dtype=np.byte)
                
                # Parse
                # First 804 bytes are 201 integers (int32)
                nbr_cls = np.frombuffer(record_bytes[:804], dtype=np.int32)
                
                # Next 16 bytes are 2 doubles (float64)
                # growth_stats = np.frombuffer(record_bytes[804:], dtype=np.float64)
                
                dist_data.append(nbr_cls)
            except Exception:
                break
        f.close()
    except FileNotFoundError:
        print(f"File {filename} not found.")
        return None
    return np.array(dist_data)

def plot_env(data10, dt=1.0/24.0): # Assuming hourly steps? No, dt=3600s = 1h.
    # Time array
    n_steps = data10.shape[0]
    time = np.arange(n_steps) * (DT / 86400.0) # Days
    
    # Plot 1: Irradiance
    plt.figure(figsize=(10, 5))
    plt.plot(time, data10[:, 1], label='Irradiance', color='orange')
    plt.xlabel('Time (days)')
    plt.ylabel('Irradiance (W/m2)')
    plt.title('Irradiance')
    plt.grid(True)
    plt.savefig(f"{PLOT_DIR}/wcm_plots_irradiance.png")
    plt.close()
    
    # Plot 2: Temperature
    plt.figure(figsize=(10, 5))
    plt.plot(time, data10[:, 0], label='Temperature', color='red')
    plt.xlabel('Time (days)')
    plt.ylabel('Temperature (deg C)')
    plt.title('Temperature')
    plt.grid(True)
    plt.savefig(f"{PLOT_DIR}/wcm_plots_temperature.png")
    plt.close()

def plot_eco(data11):
    n_steps = data11.shape[0]
    time = np.arange(n_steps) * (DT / 86400.0) # Days
    
    plt.figure(figsize=(10, 5))
    plt.plot(time, data11[:, 0], label='Nutrients', color='blue')
    plt.plot(time, data11[:, 2], label='Phytoplankton', color='green')
    plt.plot(time, data11[:, 1], label='Detritus', color='brown')
    plt.xlabel('Time (days)')
    plt.ylabel('Concentration (mmol N/m3)')
    plt.title('Ecosystem Dynamics')
    plt.legend()
    plt.grid(True)
    plt.savefig(f"{PLOT_DIR}/wcm_plots_ecosystem.png")
    plt.close()

def plot_animation(dist_data):
    # X-axis: Optimal Temperature
    # Index 0 corresponds to 5.0 deg C, Index 200 to 25.0 deg C
    # Step = 0.1 deg C
    x_axis = np.linspace(5.0, 25.0, 201)
    
    # Generate frames every 24 steps (daily)
    n_steps = dist_data.shape[0]
    frame_files = []
    
    print("Generating animation frames...")
    for i in range(0, n_steps, 24):
        plt.figure(figsize=(8, 6))
        plt.bar(x_axis, dist_data[i, :], width=0.1, color='red', align='edge')
        plt.xlabel('Optimal Temperature (deg C)')
        plt.ylabel('Count')
        plt.title(f'Phytoplankton Trait Distribution - Day {i/24:.1f}')
        plt.ylim(0, 50) # Fixed Y-axis
        plt.xlim(5, 25)
        
        filename = f"{PLOT_DIR}/anim_frame_{i:06d}.png"
        plt.savefig(filename)
        plt.close()
        frame_files.append(filename)
        
    # Create GIF
    print("Creating GIF...")
    subprocess.run(f"convert -delay 10 -loop 0 {PLOT_DIR}/anim_frame_*.png {PLOT_DIR}/animation.gif", shell=True)
    
    # Cleanup frames (optional, maybe keep them?)
    # subprocess.run(f"rm {PLOT_DIR}/anim_frame_*.png", shell=True)
from scipy.ndimage import gaussian_filter

def plot_beckmann_heatmap(dist_data, env_data):
    """
    Generates a Beckmann-style Hovmöller diagram (Heatmap) of trait evolution.
    Uses Gaussian smoothing to create a continuous probability density field.
    """
    # X-axis: Time (Days)
    n_steps = dist_data.shape[0]
    time = np.arange(n_steps) * (DT / 86400.0)
    
    # Y-axis: Optimal Temperature (Traits)
    y_bins = np.linspace(5.0, 25.0, 201)
    
    # Transpose data: (Traits, Time)
    raw_matrix = dist_data.T.astype(float)
    
    # --- THE ELEGANCE TRICK: Gaussian Smoothing ---
    # Sigma defines the blur radius. (Y-axis sigma, X-axis sigma)
    # (1.0, 1.0) provides a sharper smoothing for high-resolution data
    smooth_matrix = gaussian_filter(raw_matrix, sigma=(1.0, 1.0))
    
    # Avoid plotting zeros in LogNorm
    smooth_matrix[smooth_matrix < 0.1] = 0.1
    
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Colormap: Use 'YlOrRd' 
    cmap = plt.cm.get_cmap('YlOrRd')
    
    X, Y = np.meshgrid(time, y_bins)
    
    # Plot using Gouraud shading for extra smoothness
    c = ax.pcolormesh(X, Y, smooth_matrix, cmap=cmap, shading='gouraud', 
                      norm=LogNorm(vmin=1.0, vmax=smooth_matrix.max()))
    
    # Overlay Environment
    ax.plot(time, env_data[:, 0], color='black', linewidth=2.0, linestyle='--', label='Env. Temp')
    
    # Styling to match the paper
    ax.set_ylabel('Optimal Temperature ($T_{opt}$)', fontsize=14)
    ax.set_xlabel('Time (Days)', fontsize=14)
    ax.set_title('Evolution of Trait Distribution', fontsize=16)
    ax.set_ylim(8, 22)
    
    # Add a clean colorbar
    cbar = plt.colorbar(c, label='Abundance Density')
    cbar.ax.tick_params(labelsize=10)
    
    plt.legend(loc='upper right', frameon=False, fontsize=12)
    plt.tight_layout()
    plt.savefig(f"{PLOT_DIR}/beckmann_elegant.png", dpi=300)
    plt.close()

def main():
    print("Reading data...")
    data10 = read_fort10(f"{DATA_DIR}/fort.10")
    data11 = read_fort11(f"{DATA_DIR}/fort.11")
    data12 = read_fort12(f"{DATA_DIR}/fort.12")
    
    if data10 is not None:
        print("Plotting Environmental Data...")
        plot_env(data10)
        
    if data11 is not None:
        print("Plotting Ecosystem Data...")
        plot_eco(data11)
        
    if data12 is not None:
        print("Plotting Animation...")
        plot_animation(data12)
        
        # Calculate Statistics for Final Time Step
        final_dist = data12[-1, :]
        x_axis = np.linspace(5.0, 25.0, 201)
        total_count = np.sum(final_dist)
        if total_count > 0:
            mean = np.sum(final_dist * x_axis) / total_count
            variance = np.sum(final_dist * (x_axis - mean)**2) / total_count
            std_dev = np.sqrt(variance)
            print(f"Final Statistics (Year 10):")
            print(f"  Total Agents: {total_count}")
            print(f"  Mean T_opt: {mean:.4f} deg C")
            print(f"  Std Dev: {std_dev:.4f} deg C")

        # Calculate Lag and Amplitude (Benchmark B)
        if data10 is not None:
            # Calculate Mean T_opt time series
            n_steps = data12.shape[0]
            mean_topt = np.zeros(n_steps)
            for i in range(n_steps):
                count = np.sum(data12[i, :])
                if count > 0:
                    mean_topt[i] = np.sum(data12[i, :] * x_axis) / count
                else:
                    mean_topt[i] = np.nan
            
            env_temp = data10[:, 0]
            
            # Analyze last 2 years to avoid transient
            steps_per_year = int(360 * 24) # 360 days * 24 hours
            start_idx = -2 * steps_per_year
            
            t_env = env_temp[start_idx:]
            t_pop = mean_topt[start_idx:]
            
            amp_env = (np.max(t_env) - np.min(t_env)) / 2.0
            amp_pop = (np.nanmax(t_pop) - np.nanmin(t_pop)) / 2.0
            amp_ratio = amp_pop / amp_env
            
            # Find lag (argmax of cross-correlation)
            # Normalize
            t_env_norm = (t_env - np.mean(t_env))
            t_pop_norm = (t_pop - np.nanmean(t_pop))
            correlation = np.correlate(t_env_norm, t_pop_norm, mode='full')
            lags = np.arange(-len(t_env) + 1, len(t_env))
            lag_steps = lags[np.argmax(correlation)]
            lag_days = lag_steps * (DT / 86400.0)
            lag_months = lag_days / 30.0
            
            print(f"Benchmark B (Seasonal):")
            print(f"  Env Amplitude: {amp_env:.4f} deg C")
            print(f"  Pop Amplitude: {amp_pop:.4f} deg C")
            print(f"  Amplitude Ratio: {amp_ratio:.4f} (Target: ~0.20)")
            print(f"  Lag: {lag_days:.1f} days ({lag_months:.2f} months) (Target: ~3 months)")

            print("Plotting Beckmann Heatmap...")
            plot_beckmann_heatmap(data12, data10)
        
    print("Done. Plots saved in plots/")

if __name__ == "__main__":
    main()
