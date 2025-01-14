tic

clc
clear
close all

%% Auto-Correlation
% Load or initialize the IQ dataset
load("../../dataset/w1.mat");

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 1;
if jam_choice == 1
    IQ_data = Nojamming;
elseif jam_choice == 2
    IQ_data = Gaussian;
elseif jam_choice == 3
    IQ_data = Sine;
end

received_signal = complex(IQ_data(:,1),IQ_data(:,2));

% Given: Received IQ data (received_signal) for BPSK modulation
fs = 900e6;             % Sampling frequency (Hz)
T_s = 1/1e6;            % Symbol period (seconds)
samples_per_symbol = fs * T_s; % Number of samples per symbol

% Step 1:
% Auto-correlation of the received signal
[autocorr, lags] = xcorr(received_signal,received_signal);

% Find the maximum correlation peak
[~, peak_idx] = max(autocorr);

% Determine the symbol timing offset
symbol_offset = lags(peak_idx);

% Step 2: Sampling at symbol boundaries
sample_indices = symbol_offset + samples_per_symbol/2:samples_per_symbol:length(received_signal);
sampled_signal = received_signal(sample_indices); % Sampled IQ data

% Step 3: Decision rule to reconstruct transmitted bits
decoded_bits = sampled_signal > 0; % Threshold decision: >0 for '0', <0 for '1'

% Optional: Visualization
figure;

stem(decoded_bits, 'filled', 'DisplayName', 'Decoded Bits');
title('Decoded Bit Sequence');
xlabel('Bit Index');
ylabel('Bit Value');

toc