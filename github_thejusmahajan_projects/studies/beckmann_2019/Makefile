# Compiler and Flags
FC = gfortran
FFLAGS = -fmax-stack-var-size=32768 -w -O3 -fopenmp

# Directories
SRC_DIR = src
OUTPUT_DIR = output

# Source Files
SRCS = $(SRC_DIR)/wcm_arrays.f90 $(SRC_DIR)/phyt_ibm.F90 $(SRC_DIR)/wcm.F90
OBJS = $(SRC_DIR)/wcm_arrays.o

# Target Executable
TARGET = $(OUTPUT_DIR)/wcm.x

# Rules
all: $(TARGET)

$(TARGET): $(SRCS)
	@mkdir -p $(OUTPUT_DIR)
	$(FC) -c $(SRC_DIR)/wcm_arrays.f90 -o $(SRC_DIR)/wcm_arrays.o
	$(FC) $(FFLAGS) -o $(TARGET) $(SRCS) -I$(SRC_DIR)

run: $(TARGET)
	@echo "Running model..."
	@cp parameters.nml $(OUTPUT_DIR)/
	@cd $(OUTPUT_DIR) && ./wcm.x

clean:
	rm -f $(TARGET) $(SRC_DIR)/*.o $(SRC_DIR)/*.mod $(OUTPUT_DIR)/*.x $(OUTPUT_DIR)/fort.* $(OUTPUT_DIR)/parameters.nml

.PHONY: all run clean
