function run_simulation(sim_number)
% This function runs a single simulation based on the input parameter
% Input:
%   sim_number: integer, the number of the simulation to run

clear; clc; close all;

fprintf('Generate config for simulation %d\n', sim_number);
[obj_configs,optimization_opt]=generate_config('is_spatial', 1,... % =1 using the SBN, =0 using the CBN.
                                               'max_time', 3600*7*24,... % max running time (in seconds).
                                               'n_check', 1e6,... % results recycling checking interval. if changed to 1e6, turn off recycling.
                                               'min_cost_eval', 4,... %number of min evaluations for intensification, the larger the more stable final results are.
                                               'max_cost_eval', 8,... %number of max evaluations for intensification, the larger the more stable final results are.
                                               'x_range',[1,25; 1,25; 0,0.25; 0,0.25; 0,0.25; -150,0; 0,150; -150,0; 0,150; 0,150; 0,150],... % search region, in [n_params, 2]. For the SBN, this correspond to: taudsynI, taudsynE, mean_sigmaRRIs, mean_sigmaRREs, mean_sigmaRXs, JrEI, JrIE, JrII, JrEE, JrEX, JrIX
                                               'real_data_name', strcat('dave_',string(sim_number)),... % name pattern for the target stats, must be placed under /data.
                                               'filename', strcat('dave_output_',string(sim_number))); % name pattern for the logging files, will be placed under /results. Note: filename must end with "_bo_output_" for the recyling mechanism to identify all concurrent files

fprintf('Starting optimization using Bayesian optimization for simulation %d\n', sim_number);
% Assuming `run_bayes` is modified to be compatible with compiled code
run_bayes(obj_configs, optimization_opt, 1); % Direct call without `batch`
fprintf('Optimization completed for simulation %d\n', sim_number);
end