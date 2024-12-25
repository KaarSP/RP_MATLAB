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
% 3. Neither the name of [Your Name or Organization] nor the names of its 
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

%%
clc;
clear;
close all;
%%
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

% Parameters
num_samples = size(IQ_data,1);  % Total number of samples
window_size = 10;               % Window size for the calculation of Standard Deviation

% Calculate amplitude of each IQ pair
IQ_amplitude = IQ_data(:,1).^2 + IQ_data(:,2).^2;

% Removing zeros in the amplitude
IQ_amplitudes = IQ_amplitude(IQ_amplitude ~= 0);

% Recceived Signal Strength (RSS)
rss_dBm = 30 + 10*log10(IQ_amplitudes); % RSS in dBm

% Power associated with the Noise - Calculation
power_dBm = [];

for k = 1 : 1000%floor(num_samples/window_size)

    % Get the current window - 10 samples
    window_start = (k - 1) * window_size + 1;
    window_end   = k * window_size;
    window_data  = IQ_amplitudes(window_start:window_end);

    mean_amp     = mean(window_data);            % Mean 
    squ_dev      = (window_data - mean_amp).^2;  % Sqaured Deviation 
    expectation  = mean(squ_dev);                % Expectation
    std_dev      = sqrt(expectation);            % Standard Deviation
     
    N_dBM        = 30 + 10*log10(std_dev);       % Noise Power
     
    power_dBm    = [power_dBm; N_dBM];   
end

% Repeat the Noise Power elementwise for window size
power_dBm = repelem(power_dBm, window_size);

% Signal-to-Noise (SNR) Calculation
SNR_dB = rss_dBm(1:10000) - power_dBm;

% SNR - Plot
figure;
plot(SNR_dB);
title('Signal-to-Noise Ratio (dB)');
xlabel('Number of Samples');
ylabel('SNR (dB)');

%%

% Ensure all values are positive to fit
shift_value = abs(min(SNR_dB)) + 1; 
life = SNR_dB + shift_value;

% Distribution fit of SNR
binWidth = 2;
lastVal = ceil(max(life));
binEdges = 0:binWidth:lastVal+1;
h = histogram(life,binEdges);
xlabel('SNR (dB)');
ylabel('Frequency');

counts = histcounts(life,binEdges);
binCtrs = binEdges(1:end-1) + binWidth/2;
h.FaceColor = [.9 .9 .9];
hold on
plot(binCtrs,counts,'o');
hold off

pd = fitdist(life,'Weibull');
h = histogram(life,binEdges,'Normalization','pdf','FaceColor',[.9 .9 .9]);
xlabel('SNR (dB)');
ylabel('Probability Density Function');
xgrid = linspace(0,100,10000)';
pdfEst = pdf(pd,xgrid);
line(xgrid,pdfEst)