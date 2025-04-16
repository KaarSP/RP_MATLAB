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
% Author: Kaarmukilan

clc
clear
close all

% Parameters
jamIndex1 = 1:23;  % Constant Jamming Distance
jamIndex2 = 24:31; % Constant Relative Jamming Power

% dB values
load EVM_dB_noJam.mat % No Jamming
load EVM_dB_gauss.mat % Gauss
load EVM_dB_sine.mat  % Sine

% Select the dataset to be plotted
dataset = 3;  % Values from 1 to 31

data = EVM_noJam(dataset,:);

% Fit a normal distribution
pd = fitdist(data', 'Normal');

% Generate PDF
x = linspace(min(data), max(data), 100);
y = pdf(pd, x);

% Plot histogram and fitted curve
figure;
histogram(data, 'Normalization', 'pdf', 'NumBins', 20); hold on;
plot(x, y, 'r-', 'LineWidth', 2);

% % Add peak point (mean of fitted normal distribution)
% [~, idx_peak] = max(y); % peak index in y
% x_peak = x(idx_peak);   % x value at peak
% y_peak = y(idx_peak);   % y value at peak

% Alternatively, just use the mean as the peak (since it's a Normal dist)
x_peak = pd.mu;
y_peak = pdf(pd, x_peak);

% Plot the peak
plot(x_peak, y_peak, 'g*', 'MarkerSize', 8);
% text(x_peak, y_peak + 0.01, sprintf('Peak at %.2f', x_peak), 'HorizontalAlignment', 'center');

% Labels and formatting
xlabel('Value');
ylabel('Probability Density');
legend('Data Histogram', 'Fitted Normal PDF', 'Peak');
title('Histogram with Normal Fit and Peak');
grid on;