tic

clc;
clear;
close all;

%% Auto-Correlation
% Load or initialize the IQ dataset
load("../../dataset/w1.mat");

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 3;
if jam_choice == 1
    IQ_data = Nojamming;
elseif jam_choice == 2
    IQ_data = Gaussian;
elseif jam_choice == 3
    IQ_data = Sine;
end

received_signal = complex(IQ_data(:,1),IQ_data(:,2));

% Auto-correlation of the received signal
[autocorr, lags] = xcorr(received_signal,received_signal);

% Find the maximum correlation peak
[~, peak_idx] = max(autocorr);

% Determine the symbol timing offset
symbol_offset = lags(peak_idx);


toc