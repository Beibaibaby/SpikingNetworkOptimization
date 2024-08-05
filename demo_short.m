%% Quick demonstration of SNOPS (running time ~ 10 mins)
% This script contains a quick demo for SNOPS. Here we customize a SBN with 2 free
% parameters to the model generated spiking activity. 
% We use six activity statistics, including the firing rate, Fano factor,
% spike count correlation (rsc), and three factor-analysis based statistics
% (the percent shared variance, dimensionality of the shared variance, and
% the eigenspectrum of the shared variance), to compare model spiking
% activity to that of the target.
% Make sure you cd to /SpikingNetworkOptimization .
% The algorithm should return a parameter set with a close match of the
% groundtruth activity statistics after around 15 iterations (~10 mins on
% a desktop). For a more stable customization process, we recommend
% generating both the target and model spike trains with substantially
% longer T (see below), as shown in the manuscript.

 

clear; clc; close all;
%addpath('src')

%Specify input variables
target_stats_name = 'short_demo_sbn_simu'; % target activity statistics generated by a SBN.
simulator = @(input_para, T)simulator_short_demo(input_para, T); % function handle to the network model. Please refer to /src/simulator_short_demo.m if you want to use your own network model.
parameter_range = [1, 25; 0, 0.25]; % [n_parameters, 2]; search range for the parameters. Here we customize the inhibitory synaptic decay time constant and recurrent inhibitory connection width. In the manuscript, we customize 8 free parameters for the CBN and 11 free parameters for the SBN.
max_iter = 15; % stopping criterion (in iterations). Setting this to a larger number may lead to a more optimal result.
T = 10000; % network model simulation length (in ms). Note that this is substantially smaller than the number we used in the manuscript (140,500 ms). We use 10,000 ms only for the quick demonstration purpose, and we recommend using a much longer simulation length for stable estimation of the activity statistics. 
save_name = 'short_demo'; % name of the log file for customization. You can find it under the data folder. ex1.mat contains optimization information, ex1_stats.mat contains the activity statistics of each iteration.
is_plot=0; % If visualization of the customization process is displayed. When turned off, customization information will be printed to the stdout.

%Run the main customization function. An example result figure is included in the /results folder.
SNOPS_short_demo(target_stats_name, simulator, parameter_range, max_iter, T, save_name, is_plot);
