#!/bin/bash

# Directory where your MATLAB files and scripts are located
WORK_DIR="/gpfs/data/doiron-lab/draco/AD_codes/SpikingNetworkOptimization"

module load matlab

# Loop through simulations 1 to 10
for i in {1..10}
do
    # Compile the MATLAB script
    mcc -m run_simulation.m -a src -a src/fa_Yu -o dave_${i}

    # Create a temporary SLURM script for this job
    cat << EOF > temp_dave_${i}.sh
#!/bin/bash
#SBATCH --job-name=dave${i}
#SBATCH --account=doiron-lab
#SBATCH --partition=tier1q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=200:00:00
#SBATCH --mem=50GB
#SBATCH --output=/gpfs/data/doiron-lab/draco/out_dave/dave_demo.%j.txt
#SBATCH --error=/gpfs/data/doiron-lab/draco/out_dave/dave_demo.%j.err

module load matlab

export LD_LIBRARY_PATH=/apps/commercial/software/matlab/2019b/bin/glnxa64:/apps/commercial/software/matlab/2019b/runtime/glnxa64:$LD_LIBRARY_PATH

cd ${WORK_DIR}

./dave_${i} ${i}
EOF

    # Submit the job
    sbatch temp_dave_${i}.sh

    # Remove the temporary script
    rm temp_dave_${i}.sh

    # Wait for a short time to avoid overwhelming the scheduler
    sleep 5
done