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

numDataset = 31; % Total number of dataset

% Initialization
SNR_matrix = zeros(numDataset,4);
SNR_matrix(1:numDataset,1) = 1:numDataset;

for ii = 1%1:numDataset
    tic
    % Load or initialize the IQ dataset
    fileName = sprintf("../dataset/w%d.mat",ii);
    [~, fname, ~] = fileparts(fileName);
    fprintf("Dataset: %s\n", fname)
    load(fileName);
    fprintf('Dataset Loaded\n')
    for i = 1:3
    
        % Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
        jam_choice = i;
        if jam_choice == 1
            name = 'NoJam';
            IQ_data = Nojamming;
        elseif jam_choice == 2
            name = 'Gauss';
            IQ_data = Gaussian;
        elseif jam_choice == 3
            name = 'Sine ';
            IQ_data = Sine;
        end
        
        % Parameters        
        window_size = 10;               % Window size for the calculation of Standard Deviation        
        samplesPerImage = 5*(10^5);     % Number of samples per image

        % Index range for images
        imageStart = 1;     % Starting image index
        imageEnd   = 1;   % Ending image index

        % Calculate the start and end sample indices
        startIndex = (imageStart - 1) * samplesPerImage + 1;
        endIndex = imageEnd * samplesPerImage;

        % IQ data for the selected Images
        iqData = IQ_data(startIndex:endIndex,:);

        % Calculate amplitude of each IQ pair
        power_signal  = iqData(:,1).^2 + iqData(:,2).^2;
        
        % Removing zeros in the amplitude
        power_signal = power_signal(power_signal ~= 0);
        
        % Recceived Signal Strength (RSS)
        P_rx_dBm = 30 + 10*log10(power_signal);
        
        num_samples = length(iqData);
        noise_power = zeros(num_samples - window_size + 1, 1);

        for j = 1:(num_samples - window_size + 1)
            
            % Extract windowed samples
            I_win = iqData(j:j+window_size-1,1);
            Q_win = iqData(j:j+window_size-1,2);
            
            % Compute mean of amplitude
            amp = sqrt(I_win.^2 + Q_win.^2);
            mu = mean(amp);
            
            % Compute standard deviation (noise power)
            noise_power(j) = mean((amp - mu).^2);
        end
        
        N_dBm = 30 + 10*log10(noise_power);
        
        SNR_dB = P_rx_dBm(1:length(N_dBm)) - N_dBm;

        % % Plot results
        % figure;
        % plot(SNR_dB);
        % xlabel('Sample Index');
        % ylabel('SNR (dB)');
        % title('Estimated SNR from Received IQ Data');
        % grid on;

        fprintf('%s: SNR(max): %.2f dB\n',name, mean(SNR_dB))
    
        SNR_matrix(ii,i+1) = mean(SNR_dB); 

        % x_limits = xlim();
        % y_limits = ylim();
        % x_pos = x_limits(1) + 0.005 * (x_limits(2) - x_limits(1));
        % y_pos = y_limits(2) - 0.035 * (y_limits(2) - y_limits(1));
        % text(x_pos, y_pos, sprintf('SNR(max): %.2f dB', num2str(mean(SNR_dB))), 'FontSize', 12, 'Color', 'red');

    end
    toc
end

% save SNR_values.mat SNR_matrix
