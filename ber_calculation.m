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
load("../w1.mat");

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 2;
if jam_choice == 1
    IQ_data = Nojamming;
elseif jam_choice == 2
    IQ_data = Gaussian;
elseif jam_choice == 3
    IQ_data = Sine;
end

img = 75;  % Number of images to be considered
k2 = 5*(10^5);
k1 = img*5*(10^5);

% received_IQ = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2));
received_IQ = complex(IQ_data(1:k1,1),IQ_data(1:k1,2));

% Estimation of the transmitted sequence from No jamming scenario
transmitSeq = transmitSeqEstimate(complex(Nojamming(1:k2,1),Nojamming(1:k2,2)));

[autocorr, lags] = xcorr(real(received_IQ),transmitSeq);     % Auto-correlation of the baseband signal
% Focus on positive lags
positiveLags = autocorr(length(received_IQ):end,1);

[~, locs] = findpeaks(positiveLags, 'MinPeakHeight', max(positiveLags)*0.8);
sequenceStart = locs(1)-1; % Length of the repeating sequence

received_dat = received_IQ(sequenceStart+1:end);

len = floor(length(received_dat)/length(transmitSeq));

received_data = received_dat(1:len*length(transmitSeq));

% Step 5: Bit Error Rate (BER) calculation
received_bits = real(received_data) > 0;

transmit_bits = real(transmitSeq) > 0;
transmit_bits = repmat(transmit_bits,len,1);

% Assuming 'transmitted_bits' and 'estimated_bits' are available
if length(received_bits) ~= length(transmit_bits)
    error('Transmitted and estimated bit sequences must have the same length.');
else
    % Calculate the number of bit errors
    num_errors = sum(received_bits ~= transmit_bits);
    
    % Calculate the Bit Error Rate (BER)
    BER = num_errors / length(received_bits);
    
    % Display the result
    disp(['Number of Bit Errors: ', num2str(num_errors)]);
    disp(['Bit Error Rate (BER): ', num2str(BER)]);
end

toc