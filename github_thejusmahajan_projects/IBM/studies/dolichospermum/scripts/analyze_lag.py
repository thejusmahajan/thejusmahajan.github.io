import numpy as np
import matplotlib.pyplot as plt
from scipy.io import FortranFile
from scipy.ndimage import gaussian_filter
from scipy.signal import correlate
import os
import sys

# Configuration
PLOT_DIR = "plots"
os.makedirs(PLOT_DIR, exist_ok=True)

# Parameters
OUTPUT_DT = 86400.0 # Daily output

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

def calculate_lag(time, env_temp, mean_topt):
    """
    Calculate lag between environmental temperature and mean trait.
    Focus on the last 5 years to ensure steady state.
    """
    n_steps = len(time)
    start_idx = n_steps // 2 # Last half
    
    t_segment = time[start_idx:]
    env_segment = env_temp[start_idx:]
    trait_segment = mean_topt[start_idx:]
    
    # Normalize
    env_norm = (env_segment - np.mean(env_segment)) / np.std(env_segment)
    trait_norm = (trait_segment - np.mean(trait_segment)) / np.std(trait_segment)
    
    # Cross-correlation
    correlation = correlate(env_norm, trait_norm, mode='full')
    lags = np.arange(-len(env_norm) + 1, len(env_norm))
    
    lag_idx = lags[np.argmax(correlation)]
    lag_days = lag_idx * (OUTPUT_DT / 86400.0)
    
    # Positive lag means env leads trait (trait lags behind env)
    # Wait, correlate(a, b). If a is shifted right relative to b, peak is at positive lag?
    # Let's verify. If env peaks at t=100 and trait at t=110.
    # env(t) ~ trait(t-10).
    # correlate(env, trait). env is "fixed". trait slides.
    # We need to shift trait to the LEFT (negative lag) to match env?
    # Or shift env to the RIGHT?
    
    # Let's use peak finding for simplicity and robustness.
    from scipy.signal import find_peaks
    
    peaks_env, _ = find_peaks(env_segment, distance=300)
    peaks_trait, _ = find_peaks(trait_segment, distance=300)
    
    if len(peaks_env) == 0 or len(peaks_trait) == 0:
        return np.nan
        
    # Find closest trait peak for each env peak
    lags = []
    for p_env in peaks_env:
        # Find closest trait peak that is AFTER the env peak (causality)
        # But lag could be small negative due to noise? No, should be positive.
        
        # Look for trait peak in [p_env, p_env + 180] (within half a year)
        candidates = peaks_trait[(peaks_trait >= p_env) & (peaks_trait < p_env + 180)]
        if len(candidates) > 0:
            lags.append(candidates[0] - p_env)
            
    if len(lags) > 0:
        avg_lag_days = np.mean(lags) * (OUTPUT_DT / 86400.0)
        return avg_lag_days
    else:
        return np.nan

def analyze_lag(data_dir, label):
    print(f"Analyzing {label} in {data_dir}...")
    data10 = read_fort10(f"{data_dir}/fort.10")
    data12 = read_fort12(f"{data_dir}/fort.12")
    
    if data10 is None or data12 is None:
        return

    n_steps = data12.shape[0]
    time = np.arange(n_steps) * (OUTPUT_DT / 86400.0) / 360.0 # Years
    y_bins = np.linspace(5.0, 25.0, 201)
    
    # Calculate Mean T_opt
    mean_topt = np.zeros(n_steps)
    for i in range(n_steps):
        count = np.sum(data12[i, :])
        if count > 0:
            mean_topt[i] = np.sum(data12[i, :] * y_bins) / count
        else:
            mean_topt[i] = np.nan
            
    env_temp = data10[:n_steps, 0]
    
    # Calculate Lag
    lag_days = calculate_lag(time, env_temp, mean_topt)
    print(f"Evolutionary Lag for {label}: {lag_days:.2f} days")
    
    # Plot
    fig, ax = plt.subplots(figsize=(10, 6))
    
    # Plot last 3 years
    start_idx = max(0, n_steps - 3 * 360)
    t_plot = time[start_idx:]
    env_plot = env_temp[start_idx:]
    trait_plot = mean_topt[start_idx:]
    
    ax.plot(t_plot, env_plot, 'k-', linewidth=1.5, label='Environment Temp')
    ax.plot(t_plot, trait_plot, 'b--', linewidth=2.0, label=f'Mean $T_{{opt}}$ (Lag: {lag_days:.1f} days)')
    
    ax.set_ylabel('Temperature [°C]')
    ax.set_xlabel('Time [Years]')
    ax.set_title(f'Evolutionary Lag: {label}')
    ax.legend()
    ax.grid(True, alpha=0.3)
    
    filename = f"lag_analysis_{label.lower().replace(' ', '_')}.png"
    plt.savefig(f"{PLOT_DIR}/{filename}", dpi=300)
    plt.close()
    print(f"Generated {filename}")

if __name__ == "__main__":
    if len(sys.argv) > 1:
        # Run on specific directory
        analyze_lag(sys.argv[1], sys.argv[2])
    else:
        # Default behavior (run on both if available)
        # 1. Generic Model (Parent directory output)
        if os.path.exists("../output/fort.12"):
            analyze_lag("../output", "Generic Model")
        
        # 2. Dolichospermum (Current directory output)
        if os.path.exists("output/fort.12"):
            analyze_lag("output", "Dolichospermum")
