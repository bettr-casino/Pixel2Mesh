#!/bin/bash

# Set the environment name
ENV_NAME="test-pixel2mesh-compat"

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Remove the environment if it exists
mamba env remove -n $ENV_NAME -y

# Create the Conda environment with Python 3.10
mamba create -n $ENV_NAME python=3.10 -y

# Activate the environment
source activate $ENV_NAME

# Install specific versions of TensorFlow and related packages
pip install tensorflow-macos==2.9.0
pip install tensorflow-metal==0.6.0
pip install numpy==1.24.3
pip install h5py==3.8.0
pip install Pillow==8.4.0
pip install matplotlib==3.4.3  # Add matplotlib installation
pip install scikit-learn==0.24.2  # Optional: Add other necessary dependencies
pip install Cython==0.29.24  # Install Cython
pip install setuptools==58.0.0  # Install setuptools

# Install necessary build tools
brew install gcc

# Install tflearn from local repo
pip install -e "$SCRIPT_DIR/../tflearn"

# Set the PYTHONPATH to include the Pixel2Mesh directory
export PYTHONPATH=$(pwd):$PYTHONPATH

# Verify TensorFlow installation
python -c "import tensorflow as tf; print(f'TensorFlow version: {tf.__version__}')"
python -c "import tensorflow.compat.v1 as tf; print('TensorFlow compat.v1 imported successfully')"
python -c "import numpy as np; print(f'NumPy version: {np.__version__}')"

# Run the existing test script
python p2m/test_compat.py
