function monkey_simulation(monkey_number)
% This function runs a single simulation based on the input monkey number
% Input:
%   monkey_number: integer or string, the number of the monkey dataset to process

% Convert input to string if it's not already
monkey_num = num2str(monkey_number);

% Clear workspace, but don't clear persistent variables or globals
clearvars -except monkey_num
clc; 
close all;

fprintf('Debug: Received monkey number: %s\n', monkey_num);

% Construct the filename
filename = sprintf('./data/monkey_%s.mat', monkey_num);
fprintf('Debug: Attempting to load file: %s\n', filename);

% Check if the file exists
if ~exist(filename, 'file')
    error('File does not exist: %s', filename);
end

fprintf('Generate config for monkey %s\n', monkey_num);
[obj_configs,optimization_opt]=generate_config('is_spatial', 1,... % =1 using the SBN, =0 using the CBN.
                                               'max_time', 3600*7*24,... % max running time (in seconds).
                                               'n_check', 1e6,... % results recycling checking interval. if changed to 1e6, turn off recycling.
                                               'min_cost_eval', 4,... %number of min evaluations for intensification, the larger the more stable final results are.
                                               'max_cost_eval', 8,... %number of max evaluations for intensification, the larger the more stable final results are.
                                               'x_range',[1,25; 1,25; 0,0.25; 0,0.25; 0,0.25; -150,0; 0,150; -150,0; 0,150; 0,150; 0,150],... % search region, in [n_params, 2]. For the SBN, this correspond to: taudsynI, taudsynE, mean_sigmaRRIs, mean_sigmaRREs, mean_sigmaRXs, JrEI, JrIE, JrII, JrEE, JrEX, JrIX
                                               'real_data_name', sprintf('monkey_%s', monkey_num),... % name pattern for the target stats, must be placed under /data.
                                               'filename', sprintf('monkey_output_%s', monkey_num)); % name pattern for the logging files, will be placed under /results. Note: filename must end with "_bo_output_" for the recyling mechanism to identify all concurrent files



fprintf('Starting optimization using Bayesian optimization for monkey %s\n', monkey_num);
% Assuming `run_bayes` is modified to be compatible with compiled code
run_bayes(obj_configs, optimization_opt, 1); % Direct call without `batch`
fprintf('Optimization completed for monkey %s\n', monkey_num);
end