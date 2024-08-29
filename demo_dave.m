%% Full demonstration of SNOPS (running time ~ 168 hours)
% This script demonstrates the customization of a SBN to 10 example simulation 
% datasets generated  by the SBN with varying parameter sets.
% Make sure you cd to /SpikingNetworkOptimization, 
% then execute the following scripts to generate the config files and start SNOPS. 
% For details on the customization configurations, please refer to the documentation of generate_config.m
% The code below assumes you are running on a machine with at least 10 CPU cores, 
% as it will spawn  10 batch jobs in the background and use the results recycling mechanism 
% which routinely checks the saved results from the concurrent threads. 
% Expect 7 days to finish the full customization (slurm/screen/tmux recommended), but you may
% be able to obtain reasonable results for some of the target datasets after  48-72 hours. 
% If you do not want to use results recycling, simply change n_check to 1e6, which corresponds to 
% the routine interval for the recycling. This may possibly yield slower convergence or suboptimal results.
% You can load the log file under the results folder with the script below after or during the customization.


clear; clc; close all;

for i = 2:2
    fprintf('Generate config for simulation %d\n', i);
    [obj_configs,optimization_opt]=generate_config('is_spatial', 1,... % =1 using the SBN, =0 using the CBN.
                                                   'max_time', 3600*7*24,... % max running time (in seconds).
                                                   'n_check', 1e6,... % results recycling checking interval. if changed to 1e6, turn off recycling.
                                                   'min_cost_eval', 4,... %number of min evaluations for intensification, the larger the more stable final results are.
                                                   'max_cost_eval', 8,... %number of max evaluations for intensification, the larger the more stable final results are.
                                                   'x_range',[1,25; 1,25; 0,0.25; 0,0.25; 0,0.25; -150,0; 0,150; -150,0; 0,150; 0,150; 0,150],... % search region, in [n_params, 2]. For the SBN, this  correspond to: taudsynI, taudsynE, mean_sigmaRRIs, mean_sigmaRREs, mean_sigmaRXs, JrEI, JrIE, JrII, JrEE, JrEX, JrIX
                                                   'real_data_name', strcat('dave_',string(i)),... % name pattern for the target stats, must be placed under /data.
                                                   'filename', strcat('dave_output_',string(i))); % name pattern for the logging files, will be placed under /results. Note: filename must end with "_bo_output_" for the recyling mechanism to identify all concurrent files

    fprintf('Starting optimization using Bayesian optimization for simulation %d\n', i);
    % Assuming `run_bayes` is modified to be compatible with compiled code
    run_bayes(obj_configs, optimization_opt, 1); % Direct call without `batch`
    fprintf('Optimization completed for simulation %d\n', i);
end



