% COPYRIGHT © 2025 FAU
% 
% This MATLAB script is the intellectual property of FAU.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, 
%    this list of conditions, and the following disclaimer.
% 2. Redistributions in binary form must reproduce the above copyright notice, 
%    this list of conditions, and the following disclaimer in the documentation 
%    and/or other materials provided with the distribution.
% 3. Neither the name of FAU nor the names of its 
%    contributors may be used to endorse or promote products derived from 
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, 
% INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND 
% FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE 
% COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
% SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, 
% PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; 
% OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, 
% WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.
%
% Authour: Kaarmukilan

tic

clc
clear
close all

%% Auto-Correlation
% Load or initialize the IQ dataset
load("../w1.mat");

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 1;
if jam_choice == 1
    IQ_data = Nojamming;
elseif jam_choice == 2
    IQ_data = Gaussian;
elseif jam_choice == 3
    IQ_data = Sine;
end

l = 5*(10^5);
k1 = 5*(10^5);

received_signal = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2)); % Taking only one image
% received_signal = complex(IQ_data(:,1),IQ_data(:,2)); % Assumimg the full dataset

% Parameters
fs = 1e6;               % Sampling frequency (1 Million samples per second)
fc = 900e6;             % Carrier frequency (900MHz)
Ts = 1e-3;             % Symbol period (second)
samples_per_symbol = fs * Ts; % Number of samples per symbol
N = length(received_signal);

% Step 1: Adaptive Gain Control (AGC)
agc_gain = sqrt(mean(abs(received_signal).^2));     % RMS Amplitude
received_signal_agc = received_signal /agc_gain;    % Normalized Signal

% Step 2: Symbol synchronization
[autocorr, lags] = xcorr(abs(received_signal_agc),'coeff'); % Auto-correlation
[~, peak_idx] = max(autocorr);                              % Maximum correlation peak
symbol_offset = lags(peak_idx);                             % Symbol timing offset

% Step 3: Costas Loop (Carrier Frequency Lock and Downconversion)
% Initialize variables
phase_error     = 0;
carrier_phase   = 0;
carrier_freq    = fc / fs; % Normalized carrier frequency
baseband_signal = zeros(1, N);

% Loop to process received signal
for k = 1:N
    % Multiply with estimated carrier signal
    baseband_signal(k) = received_signal_agc(k) * exp(-1j * 2 * pi * carrier_phase);

    % Calculate phase error (decision-directed BPSK)
    phase_error = angle(baseband_signal(k) * conj(sign(real(baseband_signal(k)))));

    % Update carrier phase
    carrier_phase = carrier_phase + carrier_freq - phase_error * 0.01; % Loop gain
end

% Step 4: Constellation Decoder
% Sample the signal at symbol boundaries
sample_indices = symbol_offset + samples_per_symbol/2:samples_per_symbol:N; % Sampling points
sampled_signal = real(baseband_signal(sample_indices)); % Extract real part

% Step 5: Decision rule to reconstruct transmitted bits
estimated_bits = sampled_signal > 0; % Threshold decision: >0 for '0', <0 for '1'

% Step 5: Bit Error Rate (BER) calculation
received_bits = abs(received_signal_agc) > 0;

% Assuming 'transmitted_bits' and 'estimated_bits' are available
if length(received_bits) ~= length(estimated_bits)
    error('Transmitted and estimated bit sequences must have the same length.');
else
    % Calculate the number of bit errors
    num_errors = sum(received_bits ~= estimated_bits);
    
    % Calculate the Bit Error Rate (BER)
    BER = num_errors / length(received_bits);
    
    % Display the result
    disp(['Number of Bit Errors: ', num2str(num_errors)]);
    disp(['Bit Error Rate (BER): ', num2str(BER)]);
end

[length(estimated_bits) length(received_bits)]
