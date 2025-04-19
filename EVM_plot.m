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

% Jamming Power (dBm)
% jamPower = [0.1 0.3 0.6 0.1 0.3 0.6 0.2 0.2 0.4 0.4 0.5 0.5 0.7 0.7 0.8 0.8 0.6 0.6 repmat(0.5,1,13)]; % RJP
jamPower = [-13 -7  2.8 -13 -7  2.8 -10 -10 -3.5 -3.5 0 0   6   6   9   9   2.8 2.8 zeros(1,13)];

% Jammind Distance (m)
jamDistance = [repmat(10,1,23) 3 5 7 10 13 16 19 21];

% Load the calculated EVM values

% dB values
load EVM_dB_values.mat 

noJam_dB = EVM_dB_matrix(:,2);
gauss_dB = EVM_dB_matrix(:,3);
sine_dB  = EVM_dB_matrix(:,4);

% % percentage values
% load EVM_rms_values.mat
% 
% noJam_rms = EVM_rms_matrix(:,2);
% gauss_rms = EVM_rms_matrix(:,3);
% sine_rms  = EVM_rms_matrix(:,4);

% Plot
y1_value1 = -14.93;  % EVM threshold for constant Jamming Distance 
y1_value2 = -8;  % EVM threshold for constant Jamming Distance 
y2_value1 = -14.7;   % EVM threshold for constant Relative Jamming Power
y2_value2 = -8;   % EVM threshold for constant Relative Jamming Power

figure;
plot(jamPower(jamIndex1),noJam_dB(jamIndex1),'*');
hold on;
plot(jamPower(jamIndex1),gauss_dB(jamIndex1),'m*');
hold on;
plot(jamPower(jamIndex1),sine_dB(jamIndex1),'g*');
hold on;
xticks(-13:2:10);
yline(y1_value1, '--r', 'LineWidth', 1.5);  
text(max(jamPower)-2.7, y1_value1 + 0.05, [num2str(y1_value1),'dB'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 11, 'Color','r');
yline(y1_value2, '--r', 'LineWidth', 1.5);  
text(max(jamPower)-1.5, y1_value2, [num2str(y1_value2),'dB'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 11, 'Color','r');
figName = sprintf('Jamming Power vs EVM (Constant Jamming Distance: 10m)');
title(figName)
xlabel('Jamming Power (dBm)')
ylabel('EVM (dB)')
legend({'No Jam','Gauss','Sine'},'Location','northwest');

figure;
plot(jamDistance(jamIndex2),noJam_dB(jamIndex2),'*');
hold on;
plot(jamDistance(jamIndex2),gauss_dB(jamIndex2),'m*');
hold on;
plot(jamDistance(jamIndex2),sine_dB(jamIndex2),'g*');
hold on;
xticks([1:2:21 22]);
yline(y2_value1, '--r', 'LineWidth', 1.5);  
text(max(jamDistance) -2, y2_value1, [num2str(y2_value1),'dB'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 11, 'Color','r');
yline(y2_value2, '--r', 'LineWidth', 1.5);  
text(max(jamDistance) -1, y2_value2, [num2str(y2_value2),'dB'], 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left', 'FontSize', 11, 'Color','r');
title('Jamming Distance vs EVM (Constant Jamming Power: 0dBm)')
xlabel('Jamming Distance (m)')
ylabel('EVM (dB)')
legend({'No Jam','Gauss','Sine'},'Location','northwest');
axis([0 22 -16 0])