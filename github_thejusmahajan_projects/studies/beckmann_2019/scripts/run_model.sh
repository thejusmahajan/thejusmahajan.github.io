#!/bin/bash

# Define directories
BASE_DIR=$(pwd)
SRC_DIR="$BASE_DIR/../src"
OUTPUT_DIR="$BASE_DIR/../output"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Go to output directory to run the model (so fort.* files are created there)
cd "$OUTPUT_DIR" || exit

# Clean up old executables and intermediate files in output dir
rm -f wcm.x wcm.f90 phyt_ibm.f90 wcm_arrays.o wcm_arrays.mod

# Copy namelist file
cp "$BASE_DIR/../parameters.nml" .

# Preprocess source files (from src to current dir)
# The -P flag inhibits generation of linemarkers in the output from the preprocessor.
cpp -P "$SRC_DIR/wcm.F90" > wcm.f90
cpp -P "$SRC_DIR/phyt_ibm.F90" > phyt_ibm.f90

# Compile
# We use gfortran directly as the code does not strictly require NCL libraries for the simulation.
# Flags:
# -fmax-stack-var-size=32768: Increase stack size for large arrays
# -w: Suppress warnings
# -O3: High optimization
echo "Compiling..."
gfortran -c "$SRC_DIR/wcm_arrays.f90"
gfortran -fmax-stack-var-size=32768 -w -O3 -fopenmp -o wcm.x wcm.f90 phyt_ibm.f90 wcm_arrays.o

# Run
if [ -f wcm.x ]; then
    echo "Compilation successful. Running model with OpenMP..."
    export OMP_NUM_THREADS=4
    time ./wcm.x
else
    echo "Compilation failed."
fi
