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

received_signal = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2));
% received_signal = complex(IQ_data(:,1),IQ_data(:,2));

% Given: Received IQ data (received_signal) for BPSK modulation
% Parameters
fs = 1e6;               % Sampling frequency (1 Million samples per second)
fc = 900e6;             % Carrier frequency (900MHz)
T_s = 1;             % Symbol period (second)
samples_per_symbol = fs * T_s; % Number of samples per symbol
N = length(received_signal);

% Step 1: Downconvert the received signal to the baseband
t = ((0:N-1)/fs).';
received_baseband = received_signal .* exp(-1j * 2 * pi * fc * t); 

% Step 2: Auto-correlation to determine symbol timing
[autocorr, lags] = xcorr(abs(received_baseband));     % Auto-correlation of the baseband signal
[~, peak_idx] = max(autocorr);                      % Find the maximum correlation peak
symbol_offset = lags(peak_idx);                     % Determine the symbol timing offset

% Step 3: Sampling at symbol boundaries
% sample_indices = symbol_offset + samples_per_symbol/2:samples_per_symbol:N;
% sampled_signal = real(received_baseband(sample_indices)); % Sampled IQ data

sampled_signal = real(received_baseband(symbol_offset+1:end));
% Step 4: Decision rule to reconstruct transmitted bits
estimated_bits = sampled_signal > 0; % Threshold decision: >0 for '0', <0 for '1'

% Step 5: Bit Error Rate (BER) calculation
received_bits = abs(received_baseband) > 0;

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

% figure;
% 
% stem(estimated_bits, 'filled', 'DisplayName', 'Decoded Bits');
% title('Decoded Bit Sequence');
% xlabel('Bit Index');
% ylabel('Bit Value');

toc