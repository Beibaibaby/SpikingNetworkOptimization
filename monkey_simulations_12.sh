#!/bin/bash

# Directory where your MATLAB files and scripts are located
WORK_DIR="/gpfs/data/doiron-lab/draco/AD_codes/SpikingNetworkOptimization"

# Array of monkey numbers
# MONKEY_NUMBERS=(27 31 34 36 38 42 43 44 45 50 56 58 62 63 66 70 72 77 94)

module load matlab

#MONKEY_NUMBERS=(27 31 38 42 45 50 56 58 62 63 66 70)

MONKEY_NUMBERS=(27 31 34 36 38 42 43 44 45 50 56 58 62 63 66 70 72 77 94)

# Loop through the monkey numbers
for monkey in "${MONKEY_NUMBERS[@]}"
do
    echo "Processing monkey number: $monkey"
    
    # Compile the MATLAB script
    mcc -m monkey_simulation_12.m -a src -a src/fa_Yu -o monkey12_${monkey}

    # Create a temporary SLURM script for this job
    cat << EOF > temp_monkey_${monkey}.sh
#!/bin/bash
#SBATCH --job-name=monnew${monkey}
#SBATCH --account=doiron-lab
#SBATCH --partition=tier1q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --time=200:00:00
#SBATCH --mem=50GB
#SBATCH --output=/gpfs/data/doiron-lab/draco/out_mon_new/marnew${monkey}.%j.txt
#SBATCH --error=/gpfs/data/doiron-lab/draco/out_mon_new/marnew${monkey}.%j.err

module load matlab

export LD_LIBRARY_PATH=/apps/commercial/software/matlab/2019b/bin/glnxa64:/apps/commercial/software/matlab/2019b/runtime/glnxa64:$LD_LIBRARY_PATH

cd ${WORK_DIR}

echo "Running monkey_${monkey} with parameter ${monkey}"
./monkey12_${monkey} ${monkey}
EOF

    # Submit the job
    sbatch temp_monkey_${monkey}.sh

    # Remove the temporary script
    rm temp_monkey_${monkey}.sh

    # Wait for a short time to avoid overwhelming the scheduler
    sleep 5
done

echo "All jobs submitted"