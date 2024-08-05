#!/bin/bash
#SBATCH --job-name=snops_demo
#SBATCH --account=doiron-lab
#SBATCH --partition=tier2q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --time=00:30:00
#SBATCH --cpus-per-task=1
#SBATCH --mem=50gb
#SBATCH --output=/gpfs/data/doiron-lab/draco/out_ad/snops_demo.%j.txt
#SBATCH --error=/gpfs/data/doiron-lab/draco/out_ad/snops_demo.%j.err

# Load the MATLAB module
module load matlab  

# Set up the environment for the MATLAB Runtime
export LD_LIBRARY_PATH=/apps/commercial/software/matlab/2019b/bin/glnxa64:/apps/commercial/software/matlab/2019b/runtime/glnxa64:$LD_LIBRARY_PATH

# Navigate to your project directory
cd /gpfs/data/doiron-lab/draco/AD_project/SpikingNetworkOptimization

# Run the compiled MATLAB executable
./short_draco