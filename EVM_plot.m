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

% Jamming ID : 4,5,6,7,8
jamID = 4;

% if jamID == 4
%     jamIndex = [1 2 3 7 9 12 13 15 18 19];
% elseif jamID == 5
%     jamIndex = [4 5 6 8 10 11 14 16 17 20];
% elseif jamID == 6
%     jamIndex = 21;
% elseif jamID == 7
%     jamIndex = 22;
% elseif jamID == 8
%     jamIndex = 23;
% end
jamIndex = 1:23;
% Jamming Power (W)
jamPower = [0.1 0.3 0.6 0.1 0.3 0.6 0.2 0.2 0.4 0.4 0.5 0.5 0.7 0.7 0.8 0.8 0.6 0.6 repmat(0.5,1,13)];

% Jammind Distance (m)
jamDistance = [repmat(10,1,23) 3 5 7 10 13 16 19 21];

load EVM_dB_values.mat 
load EVM_rms_values.mat

% dB values
noJam_dB = EVM_dB_matrix(:,2);
gauss_dB = EVM_dB_matrix(:,3);
sine_dB  = EVM_dB_matrix(:,4);

% percentage values
noJam_rms = EVM_rms_matrix(:,2);
gauss_rms = EVM_rms_matrix(:,3);
sine_rms  = EVM_rms_matrix(:,4);

figure;
plot(jamPower(jamIndex),noJam_dB(jamIndex),'r*');
hold on;
plot(jamPower(jamIndex),gauss_dB(jamIndex),'b*');
hold on;
plot(jamPower(jamIndex),sine_dB(jamIndex),'g*');
hold on;
y_value = -14;  % EVM threshold for -14dB
yline(y_value, '--k', 'LineWidth', 1.5);  
figName = sprintf('Jamming Power vs EVM');
title(figName)
xlabel('Jamming Power (W)')
ylabel('EVM (dB)')
legend({'No Jam','Gauss','Sine'},'Location','northwest');

figure;
plot(jamDistance(24:31),noJam_dB(24:31),'r*');
hold on;
plot(jamDistance(24:31),gauss_dB(24:31),'b*');
hold on;
plot(jamDistance(24:31),sine_dB(24:31),'g*');
hold on;
yline(y_value, '--k', 'LineWidth', 1.5);  
title('Jamming Distance vs EVM')
xlabel('Jamming Distance (m)')
ylabel('EVM (dB)')
legend({'No Jam','Gauss','Sine'},'Location','northwest');