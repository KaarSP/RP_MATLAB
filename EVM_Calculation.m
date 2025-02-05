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

% Load or initialize the IQ dataset
tic
fileName = "../dataset/w29.mat";
[~, fname, ~] = fileparts(fileName);
load(fileName);
toc

% Save image: (1) Save image as .jpg / (0) Don't save the image
img_save = 0; 

tic
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
        name = 'Sin';
        IQ_data = Sine;
    end
    
    img = 75;  % Number of images to be considered
    k2 = 5*(10^5);
    k1 = img*5*(10^5);
    
    % received_IQ = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2));
    received_IQ = complex(IQ_data(1:k1,1),IQ_data(1:k1,2));
    
    % Removing if there are any zeros
    received_IQ = received_IQ(real(received_IQ) ~= 0);
    
    % Assigning reference symbols
    idealSymbols = sign(real(received_IQ));
    
    % Error Vector
    errorVector = received_IQ - idealSymbols;
    
    % Compute EVM as percentage
    evm_rms = (rms(abs(errorVector)) / rms(abs(idealSymbols))) * 100;
    
    % Compute EVM in dB
    evm_db = 20 * log10((rms(abs(errorVector)) / rms(abs(idealSymbols))));
    
    sprintf('EVM (as percentage): %.2f%%', evm_rms)
    sprintf('EVM (in dB): %.2f dB', evm_db)
    
    figure;
    plot(real(received_IQ), imag(received_IQ), 'bo', 'MarkerSize', 8, 'LineWidth', 1.5); hold on;
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

    if img_save == 1
        folderPath = 'Z:\Kaarmukilan\img\';
        fileName = sprintf('EVM_%s_%s.jpg', fname,name);
        fullPath = fullfile(folderPath, fileName);
        saveas(gcf, fullPath);
    end

end

toc