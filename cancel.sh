#!/bin/bash

# Array of job IDs to cancel
job_ids=(12769328 12769301 12769279 12769244 12769193 12769172 12769137 12769102 12768813 12768653 12768607)

# Loop through the job IDs and cancel each one
for job in "${job_ids[@]}"
do
    echo "Cancelling job $job"
    scancel $job
done

echo "All specified jobs have been cancelled."