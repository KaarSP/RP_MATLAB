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

tic

clc
clear
close all

% Load or initialize the IQ dataset
tic
fileName = "../dataset/w1.mat";
[~, fname, ~] = fileparts(fileName);
load(fileName);
toc

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 1;
if jam_choice == 1
    name = 'NoJam';
    IQ_data = Nojamming;
elseif jam_choice == 2
    name = 'Gauss';
    IQ_data = Gaussian;
elseif jam_choice == 3
    name = 'Sin';
    IQ_data = Sine;
end

imageSel = 100;             % Selected Image
samplesPerImage = 5*(10^5); % Samples per image

startIndex = (imageSel - 1) * samplesPerImage + 1;
endIndex = startIndex + 2047;

receivedIQ = complex(Nojamming(startIndex:endIndex,1),Nojamming(startIndex:endIndex,2));

% Estimation of the transmitted sequence from No jamming scenario
transmitSeq = transmitSeqEstimate(receivedIQ);

[autocorr, lags] = xcorr(real(receivedIQ));     % Auto-correlation of the baseband signal
% Focus on positive lags
positiveLags = autocorr(length(received_IQ):end,1);

figure
plot(positiveLags(1:15000))
title(sprintf('%s %s', fname, name));

[~, locs] = findpeaks(abs(positiveLags), 'MinPeakHeight', max(positiveLags)*0.8, 'MinPeakDistance', 2048/2);
sequenceStart = locs(2); % Start of the repeating sequence

received_dat = received_IQ(sequenceStart:end);

len = floor(length(received_dat)/length(transmitSeq));

received_data = received_dat(1:len*length(transmitSeq));

% Step 5: Bit Error Rate (BER) calculation
estimate_bits = real(received_data) > 0;
estimate_2048 = estimate_bits(1:2048);

transmit_bits = real(transmitSeq) > 0;
transmit_2048 = transmit_bits;
transmit_bits = repmat(transmit_bits,len,1);

% Calculate the number of bit errors
error_2048 = sum(estimate_2048 ~= transmit_2048);

% Calculate the Bit Error Rate (BER)
BER_2048 = error_2048 / length(estimate_2048);

% Display the result
disp(['Number of Bit Errors 2048: ', num2str(error_2048)]);
disp(['Bit Error Rate (BER) 2048: ', num2str(BER_2048)]);

figure;
plot(transmit_2048,'b');
hold on;
plot(estimate_2048,'r');
title('Transitted and Estimated bits')
legend('Transmit Bits', 'Estimate Bits')
axis([0 2048 -1 2]);

% figure;
% plot(transmit_bits(1:2500),'b');
% hold on;
% plot(estimate_bits(1:2500),'r');
% title('Transitted and Estimated bits')
% legend('Transmit Bits', 'Estimate Bits')
% axis([0 2500 -1 2]);

if length(estimate_bits) ~= length(transmit_bits)
    error('Transmitted and estimated bit sequences must have the same length.');
else
    % Calculate the number of bit errors
    num_errors = sum(estimate_bits ~= transmit_bits);
    
    % Calculate the Bit Error Rate (BER)
    BER = num_errors / length(estimate_bits);
    
    % Display the result
    disp(['Number of Bit Errors: ', num2str(num_errors)]);
    disp(['Bit Error Rate (BER): ', num2str(BER)]);
end

toc