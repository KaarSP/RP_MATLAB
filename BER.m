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
% clearvars -except Nojamming Gaussian Sine;
close all

numDataset = 23; % Total number of dataset

% Initialization
BER_matrix = zeros(numDataset,4);
BER_matrix(1:numDataset,1) = 1:numDataset;

% Plot image: (1) Plot Constellation / (0) Don't plot the constellation
imgPlot = 0; 

for ii = 1:numDataset
    tic
    % Load or initialize the IQ dataset
    fileName = sprintf("../dataset/w%d.mat",ii);
    [~, fname, ~] = fileparts(fileName);
    fprintf("Dataset: %s\n", fname)
    load(fileName);
    
    for i = 2:3

        % Select the type of Jamming: (2) Gaussian / (3) Sine
        jam_choice = i;
        if jam_choice == 2
            name = 'Gauss';
            iqData = Gaussian;
        elseif jam_choice == 3
            name = 'Sin';
            iqData = Sine;
        end

        imageSel = 100;             % Selected Image
        samplesPerImage = 5*(10^5); % Samples per image

        startIndex = (imageSel - 1) * samplesPerImage + 1;
        endIndex = imageSel * samplesPerImage;
        Tx_endIndex   = startIndex + 2047;         % Selecting 2048 samples

        % Selecting 1 image in Jamming case
        jammedIQ   = complex(iqData(startIndex:endIndex,1),iqData(startIndex:endIndex,2));

        % Selecting 2048 samples in No Jamming case
        noJammedIQ = complex(Nojamming(startIndex:Tx_endIndex,1),Nojamming(startIndex:Tx_endIndex,2));

        % Mapping of sequence
        jammed_bits   = real(jammedIQ) > 0;
        noJammed_bits = real(noJammedIQ) > 0;

        % Cross-correlation
        [corrSignal, lags] = xcorr(jammed_bits,noJammed_bits);

        % Select only positive lags
        positiveLagsIdx = lags >= 0; % Logical index for positive lags
        lags = lags(positiveLagsIdx);
        corrSignal = corrSignal(positiveLagsIdx);

        % Define Thresholds
        maxThreshold = max(corrSignal) * 0.95;  % Only consider peaks above this value
        minThreshold = max(-corrSignal) * 0.95; % Only consider valleys below this value
        
        % Find Local Maxima Above Threshold
        [maxPeaks, maxLocs] = findpeaks(corrSignal, 'MinPeakHeight', maxThreshold);
        
        % Find Local Minima Below Threshold (by inverting signal)
        [minPeaks, minLocs] = findpeaks(-corrSignal, 'MinPeakHeight', -minThreshold);
        
        if imgPlot == 1
            % Plot Correlation Output with Threshold-Based Peaks
            figure;
            plot(lags, corrSignal, 'b', 'LineWidth', 1.2); hold on;
            plot(lags(maxLocs), maxPeaks, 'ro', 'MarkerSize', 8, 'LineWidth', 1.5); % Maxima above threshold (Red)
            plot(lags(minLocs), minPeaks, 'go', 'MarkerSize', 8, 'LineWidth', 1.5); % Minima below threshold (Green)
            yline(maxThreshold, '--r', 'Max Threshold');  % Plot threshold line
            yline(minThreshold, '--g', 'Min Threshold');  % Plot threshold line
            title('Maxima Above and Minima Below Threshold in Correlation Output');
            xlabel('Lag');
            ylabel('Correlation');
            legend('Correlation', 'Maxima Above Threshold', 'Minima Below Threshold', 'Max Threshold', 'Min Threshold');
            grid on;
        end

        % Condition to check if peak is negative
        if length(maxLocs) > 1
            diff1 = diff(maxLocs(1:end-2));
            if isempty(diff1)
                diff_max = 0;
            else
                diff_max = all(diff1 == 2048);
            end
        else
            diff_max = 0;
        end

        if length(minLocs) > 1
            diff2 = diff(minLocs(1:end-2));
            if isempty(diff2)
                diff_min = 0;
            else
                diff_min = all(diff2 == 2048);
            end
             
        else
            diff_min = 0;
        end

        if diff_min == 1
            jammedIQ = -1 * jammedIQ;
            jammed_bits   = real(jammedIQ) > 0;
            firstBit = minLocs(1);
        else
            firstBit = maxLocs(1);
        end

        % Select the actual received bits
        tx_sequence = noJammed_bits;
        rx_sequence = jammed_bits(firstBit:firstBit+2047);

        if imgPlot == 1
            figure
            plot(tx_sequence);
            hold on
            plot(rx_sequence);
            ylim([-1 2])
        end

        % Calculate the number of bit errors
        num_errors = sum(rx_sequence ~= tx_sequence);
        
        % Calculate the Bit Error Rate (BER)
        BitErrorRate = num_errors / length(rx_sequence);
        
        BER_matrix(ii,i+1) = BitErrorRate;

        % Display the result
        fprintf('Number of Bit Errors: %d\n', num_errors);
        fprintf('Bit Error Rate (BER): %d\n', BitErrorRate);

    end
    toc
end

save BER_values.mat BER_matrix