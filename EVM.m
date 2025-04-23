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

numDataset = 31; % Total number of dataset
images = 1:2:200; % Number of images selected

% Initialization
EVM_dB_matrix = zeros(numDataset,4);
EVM_dB_matrix(1:numDataset,1) = 1:numDataset;

EVM_rms_matrix = zeros(numDataset,4);
EVM_rms_matrix(1:numDataset,1) = 1:numDataset;

EVM_noJam = zeros(numDataset,length(images));
EVM_gauss = zeros(numDataset,length(images));
EVM_sine  = zeros(numDataset,length(images));

% Save image: (1) Save image as .jpg / (0) Don't save the image
imgSave = 0; 

% Plot image: (1) Plot Constellation / (0) Don't plot the constellation
imgPlot = 0; 

for ii = 1:numDataset
    tic
    % Load or initialize the IQ dataset
    fileName = sprintf("../dataset/w%d.mat",ii);
    [~, fname, ~] = fileparts(fileName);
    sprintf("Dataset: %s", fname)
    load(fileName);
    
    for i = 1:3
    
        % Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
        jam_choice = i;
        if jam_choice == 1
            name = 'NoJam';
            iqData = Nojamming;
        elseif jam_choice == 2
            name = 'Gauss';
            iqData = Gaussian;
        elseif jam_choice == 3
            name = 'Sin';
            iqData = Sine;
        end
        
        for jjj = images
            imageSel = jjj;             % Selected Image
            samplesPerImage = 5*(10^5); % Samples per image
            
            startIndex = (imageSel - 1) * samplesPerImage + 1;
            endIndex = imageSel * samplesPerImage;
        
            receivedIQ = complex(iqData(startIndex:endIndex,1),iqData(startIndex:endIndex,2));
            
            % Removing if there are any zeros
            receivedIQ = receivedIQ(real(receivedIQ) ~= 0);
            
            % Assigning reference symbols
            idealSymbols = sign(real(receivedIQ));
            
            % Error Vector
            errorVector = receivedIQ - idealSymbols;
            
            % Compute EVM as percentage
            evm_rms = (rms(abs(errorVector)) / rms(abs(idealSymbols))) * 100;
            
            % Compute EVM in dB
            evm_db = 20 * log10((rms(abs(errorVector)) / rms(abs(idealSymbols))));
            
            sprintf('EVM (as percentage): %.2f%%', evm_rms)
            % sprintf('EVM (in dB): %.2f dB', evm_db)
            
            if imgPlot == 1
                figure;
                plot(real(receivedIQ), imag(receivedIQ), 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); hold on;
                plot(real(idealSymbols), imag(idealSymbols), 'rx', 'MarkerSize', 10, 'LineWidth', 2);
                legend('Received Symbols', 'Ideal BPSK Symbols');
                xlabel('In-Phase');
                ylabel('Quadrature');
                title(sprintf('BPSK Constellation with EVM: %s - %s', fname, name));
                grid on;
                axis equal;
            
                x_limits = xlim();
                y_limits = ylim();
                x_pos = x_limits(1) + 0.1 * (x_limits(2) - x_limits(1));
                y_pos = y_limits(2) - 0.1 * (y_limits(2) - y_limits(1));
                text(x_pos, y_pos, sprintf('EVM: %.2f%%, %.2f dB', evm_rms, evm_db), 'FontSize', 12, 'Color', 'red');
            end
    
            if imgSave == 1
                folderPath = 'Z:\Kaarmukilan\img\';
                fileName = sprintf('EVM_%s_%s.jpg', fname,name);
                fullPath = fullfile(folderPath, fileName);
                saveas(gcf, fullPath);
            end
        
            % EVM_dB_matrix(ii,i+1)  = evm_db;
            % EVM_rms_matrix(ii,i+1) = evm_rms; 
    
            if jam_choice == 1
                EVM_noJam (ii,jjj) = evm_db;
            elseif jam_choice == 2
                EVM_gauss (ii,jjj) = evm_db;
            elseif jam_choice == 3
                EVM_sine (ii,jjj ) = evm_db;
            end
        end
    end
    toc
end

% save EVM_dB_values.mat EVM_dB_matrix
% save EVM_rms_values.mat EVM_rms_matrix

save EVM_dB_noJam.mat EVM_noJam
save EVM_dB_gauss.mat EVM_gauss
save EVM_dB_sine.mat EVM_sine