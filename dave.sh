#!/bin/bash
#SBATCH --job-name=dave2
#SBATCH --account=doiron-lab
#SBATCH --partition=tier1q
#SBATCH --nodes=1
#SBATCH --ntasks=1  # Use 10 tasks as the script spawns 10 batch jobs
#SBATCH --cpus-per-task=10
#SBATCH --time=200:00:00  
#SBATCH --mem=50GB  # Adjust based on your memory requirement estimation
#SBATCH --output=/gpfs/data/doiron-lab/draco/out_matt/full_snops_demo.%j.txt
#SBATCH --error=/gpfs/data/doiron-lab/draco/out_matt/full_snops_demo.%j.err

# Load the MATLAB module
module load matlab  

# Set up the environment for the MATLAB Runtime
export LD_LIBRARY_PATH=/apps/commercial/software/matlab/2019b/bin/glnxa64:/apps/commercial/software/matlab/2019b/runtime/glnxa64:$LD_LIBRARY_PATH

# Navigate to your project directory
cd /gpfs/data/doiron-lab/draco/AD_codes/SpikingNetworkOptimization

# Run the compiled MATLAB executable
./dave_2