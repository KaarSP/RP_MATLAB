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

%%
clc;
clear;
close all;

load SNR_values.mat

noJam_SNR = SNR_matrix(1:18,2);
gauss_SNR = SNR_matrix(1:18,3);
sine_SNR  = SNR_matrix(1:18,4);

% Jamming Power (W)
jamPower = [0.1 0.3 0.6 0.1 0.3 0.6 0.2 0.2 0.4 0.4 0.5 0.5 0.7 0.7 0.8 0.8 0.6 0.6];

figure;
plot(jamPower,noJam_SNR,'r*');
hold on;
plot(jamPower,gauss_SNR,'b*');
hold on;
plot(jamPower,sine_SNR,'g*');
figName = sprintf('Jamming Power vs SNR');
title(figName)
xlabel('Jamming Power (W)')
ylabel('SNR (dB)')
legend({'No Jam','Gauss','Sine'},'Location','southwest');
