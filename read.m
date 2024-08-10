% Load the data from a MAT file

clear; clc; close all;
addpath('src')

load('./data/ADdataDraco_04032024');  % Adjust the filename as needed

% Display field names and details for each field in the structure
fields = fieldnames(d);
fprintf('Fields in the structure:\n');
for i = 1:numel(fields)
    fieldValue = d.(fields{i});
    fprintf('%s: %s [%s]\n', fields{i}, class(fieldValue), mat2str(size(fieldValue)));
end

% Access and print details from specific fields
% Example: Printing day numbers and session details
%fprintf('\nSession details:\n');
%    fprintf('Entry %d - Day: %s, Session: %d, Drug Administered: %d\n', i, num2str(d(i).dayNum), d(i).session, d(i).drug);
%end

% Example usage of specific field data
% Access the first v4counts field
first_v4counts = d(1).v4counts;

% Display information about the first v4counts data
fprintf('\nFirst entry v4counts data size: %s\n', mat2str(size(first_v4counts)));

% Initialize an empty array for v4counts if dayNum 23 is not found
v4counts_day23 = [];

% Loop through each entry in the structure
for i = 1:length(d)
    if d(i).dayNum == 23  % Check if dayNum is 23
        v4counts_day23 = d(i).v4counts;  % Assign the v4counts matrix
        break;  % Exit the loop once the matrix is found
    end
end

% Check if the v4counts matrix was found and display it
if isempty(v4counts_day23)
    disp('No data for dayNum 23.');
else
    disp('v4counts matrix for dayNum 23:');
    disp(size(v4counts_day23));
end

v4counts_day23 = v4counts_day23(1:50, :);



% Define configuration parameters
obj_configs = struct();
obj_configs.n_sampling = 100;  % Example: number of samplings
obj_configs.Tw = 50;           % Example: time window size for spike counts
obj_configs.Tburn = 100;       % Example: burn-in period to exclude from analysis
obj_configs.Ne1 = 25;          % Example: number of excitatory neurons considered
obj_configs.dim_method = 'CV'; % Example: dimensionality reduction method, choose from 'PA', 'CV', 'CV_skip', 'overfit'

% Define the spike train data filename (assuming it is saved properly)
target_train_name = 'spike_data_day23';  % This should match the .mat file name without extension

% Assuming v4counts_day23 is already extracted and to be used
save('./data/spike_data_day23.mat', 'v4counts_day23');

% Call the function to compute statistics
%true_statistics = compute_target_statistics(target_train_name, obj_configs);

% Display the resulting statistics table
%disp(true_statistics);

%Compute the activity statistics of the target spike trains.
%   -Input
%     obj_configs: string; filename of the spike trains to customize network model to.  
%     obj_configs: struct, configurations for customization.

%   -Output
%      true_statistics: table, the six activity statistics of the target data


%load(strcat('./data/',target_train_name,'.mat'));
re1_s=v4counts_day23
[rate0,var0, FanoFactor0, mean_corr0] = compute_statistics_only(v4counts_day23)
rate0 = rate0*5

[fa_percentshared, fa_normevals, fa_dshared] = compute_pop_stats(sampling_inds, re, n_neuron, Tw, dim_method);


% In the manuscript, we compute the variance of each statistic over
% multiple simulations of the same network parameter set. Here we preset
% the variance using empirical numbers for simplicity.

rate_mean=rate1;
rate_var=0.1;

fano_mean=FanoFactor1; 
fano_var=0.0002;             

mean_corr_mean=mean_corr1; 
mean_corr_var=2e-6;    

fa_percent_mean=fa_percentshared;
fa_percent_var=1e-6;    

fa_dim_mean=fa_dshared; 
fa_dim_var=0.1;   

fa_normeval_mean=fa_normevals;  
fa_normeval_var=0.01;

default_weights=ones(1,6);
true_statistics=table(n_neuron,rate_mean,rate_var,fano_mean,fano_var,mean_corr_mean,mean_corr_var,fa_percent_mean,fa_percent_var,fa_dim_mean,fa_dim_var,fa_normeval_mean,fa_normeval_var,default_weights);
true_statistics
%output_file_name = strcat(target_train_name,'_stats');
%save(strcat('./data/',output_file_name,'.mat'),'true_statistics');
