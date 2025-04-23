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
% close all

% Parameters
jamIndex1 = 1:23;  % Constant Jamming Distance
jamIndex2 = 24:31; % Constant Relative Jamming Power

% dB values
load EVM_dB_noJam.mat % No Jamming
load EVM_dB_gauss.mat % Gauss
load EVM_dB_sine.mat  % Sine

w = [1 7 2 9 12 18 13 15]; % RJP: 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8

% Select the dataset to be plotted
dataset = 15;  % Values from 1 to 31
if dataset == 1
    coloring = [0.0000, 0.4470, 0.7410]; % Blue
elseif dataset == 7
    coloring = [0.8500, 0.3250, 0.0980]; % Red-Orange
elseif dataset == 2
    coloring = [0.9290, 0.6940, 0.1250]; % Yellow
elseif dataset == 9
    coloring = [0.4940, 0.1840, 0.5560]; % Purple
elseif dataset == 12
    coloring = [0.4660, 0.6740, 0.1880]; % Green
elseif dataset == 18
    coloring = [0.3010, 0.7450, 0.9330]; % Cyan
elseif dataset == 13
    coloring = [0.6350, 0.0780, 0.1840]; % Dark Red
elseif dataset == 15
    coloring = [0.3010, 0.3000, 0.8000]; % Indigo
end

option = 3; % 1: No Jamming, 2:Sine, 3:Gauss
if option == 1
    data = EVM_noJam(dataset,1:2:end);
    coloring = [0, 0, 0];
    markering = 'o';
elseif option == 2
    data = EVM_sine(dataset,1:2:end);
    markering = '*';
elseif option == 3
    data = EVM_gauss(dataset,1:2:end);
    markering = 'square';
end

% Fit a normal distribution
pd = fitdist(data', 'Normal');

% Generate PDF
x = linspace(min(data), max(data), 100);
y = pdf(pd, x);

% Alternatively, just use the mean as the peak (since it's a Normal dist)
x_peak = pd.mu;
y_peak = pdf(pd, x_peak);

% Plot histogram and fitted curve
figure;
histogram(data, 'Normalization', 'pdf', 'NumBins', 20); hold on;

% Plot line and peak together using NaN to break line continuity
x_combined = [x, NaN, x_peak];
y_combined = [y, NaN, y_peak];

h = plot(x_combined, y_combined, 'r-', 'LineWidth', 1, 'Color', coloring); 

set(h, 'Marker', markering, 'MarkerIndices', length(x_combined));  % Only the last point gets a marker

% Labels and legend
xlabel('EVM (dB)');
ylabel('Probability Density');
legend(h, 'Fitted Normal PDF with Peak');
title('Histogram with Normal Fit and Peak');
grid on;