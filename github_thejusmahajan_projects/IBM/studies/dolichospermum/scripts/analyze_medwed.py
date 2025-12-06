import numpy as np
import struct
import os

def analyze_medwed():
    filename = "output/fort.12"
    if not os.path.exists(filename):
        print(f"Error: {filename} not found.")
        return

    # Parameters
    Ms = 200
    bin_width = 0.1
    start_temp = 5.0
    
    # Data structure: 
    # nbr_cls (201 integers) + growthmean0 (double) + growthmean (double)
    # Integer size = 4 bytes, Double size = 8 bytes
    # Total data size = 201*4 + 8 + 8 = 820 bytes
    # Fortran record markers = 4 bytes before and after
    record_size = 4 + 820 + 4
    
    last_record = None
    count = 0
    
    with open(filename, "rb") as f:
        while True:
            chunk = f.read(record_size)
            if not chunk:
                break
            if len(chunk) == record_size:
                last_record = chunk
                count += 1
    
    if last_record is None:
        print("No data found.")
        return

    print(f"Read {count} records. Analyzing the final record (Year 33)...")
    
    # Unpack
    # Skip first 4 bytes (marker)
    # Read 201 integers
    # Read 2 doubles
    # Skip last 4 bytes (marker)
    
    data_chunk = last_record[4:-4]
    
    # Format: 201i (integers), 2d (doubles)
    # Use '=' to avoid alignment padding
    fmt = f"={Ms+1}i2d"
    unpacked = struct.unpack(fmt, data_chunk)

    
    nbr_cls = np.array(unpacked[:Ms+1])
    growthmean0 = unpacked[-2]
    growthmean = unpacked[-1]
    
    # Calculate Mean Topt
    total_agents = np.sum(nbr_cls)
    if total_agents == 0:
        print("No agents found in final step.")
        return
        
    weighted_sum = 0.0
    for j in range(Ms+1):
        temp_center = start_temp + j * bin_width + (bin_width / 2.0)
        weighted_sum += nbr_cls[j] * temp_center
        
    mean_topt = weighted_sum / total_agents
    
    print(f"Final Total Agents: {total_agents}")
    print(f"Final Mean Topt: {mean_topt:.4f} °C")
    
    # Validation
    target = 21.1
    diff = mean_topt - target
    print(f"Target (Medwed 2020): {target} °C")
    print(f"Difference: {diff:.4f} °C")
    
    if abs(diff) < 1.0:
        print("SUCCESS: Model reproduces the evolutionary shift!")
    else:
        print("FAIL: Model does not match the observed shift.")

if __name__ == "__main__":
    analyze_medwed()
