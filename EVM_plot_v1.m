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

% Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
jam_choice = 2;

% Save image: (1) Save image as .jpg / (0) Don't save the image
img_save = 1;

% Jamming Power (W)
jam_power = [0.1 0.3 0.6 0.1 0.3 0.6 0.2 0.2 0.4 0.4 0.5 0.5 0.7 0.7 0.8 0.8 0.6 0.6 repmat(0.5,1,13)];

% Jammind Distance (m)
jam_distance = [repmat(10,1,23) 3 5 7 10 13 16 19 21];

noJam_percent = [16.11 17.64 17.68 16.26 17.76 17.84 16.36 17.90 17.90 16.79 17.65 17.85 17.86 16.17 16.07 17.72 17.68 17.84 16.14 17.32 17.48 15.92 17.34 16.98 17.72 17.74 16.18 17.42 27.79 17.85 24.26];
noJam_dB = [-15.86 -15.07 -15.05 -15.78 -15.01 -14.97 -15.73 -14.94 -14.94 -15.50 -15.07 -14.97 -14.96 -15.83 -15.88 -15.03 -15.05 -14.97 -15.84 -15.23 -15.15 -15.96 -15.22 -15.40 -15.03 -15.02 -15.82 -15.18 -11.12 -14.97 -12.30];

gauss_percent = [18.86 22.21 41.73 17.92 17.94 18.91 19.78 17.91 25.07 19.08 20.18 28.52 38.99 57.83 85.28 81.39 19.66 31.28 35.99 33.31 24.78 26.26 33.63 25.59 39.81 35.36 41.88 54.40 79.59 42.74 56.24];
gauss_dB = [-14.49 -13.07 -7.59 -14.93 -14.92 -14.47 -14.07 -14.94 -12.02 -14.39 -13.90 -10.90 -8.18 -4.76 -1.38 -1.79 -14.13 -1.09 -8.88 -9.55 -12.12 -11.61 -9.46 -11.84 -8.00 -9.03 -7.56 -5.29 -1.98 -7.38 -5.00];

sine_percent = [19.16 24.35 56.74 17.13 17.94 18.73 21.02 17.91 28.53 20.96 22.29 31.37 50.40 68.51 51.21 68.25 34.84 43.05 54.57 39.08 28.60 22.26 26.43 26.67 38.67 21.05 50.54 63.47 73.40 44.34 61.57];
sine_dB = [-14.35 -12.27 -4.92 -15.33 -14.92 -14.55 -13.55 -14.94 -10.89 -13.57 -13.04 -10.07 -5.95 -3.28 -5.83 -3.32 -9.16 -7.32 -5.26 -8.16 -10.87 -13.05 -11.56 -11.48 -8.25 -13.53 -5.93 -3.95 -2.69 -7.07 -4.21];

% plot(noJam_percent,jam_power,'r*')

plot(jam_power,noJam_dB,'r*')

% if jam_choice == 1
%     name = 'NoJam';
%     figure(1)
%     yyaxis left;
%     plot(noJam_percent,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(noJam_percent,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM (%)')
%     title('No Jamming - %')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_percent_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
%     figure(2)
%     yyaxis left;
%     plot(noJam_dB,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(noJam_dB,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM (dB)')
%     title('No Jamming - dB')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_dB_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
% elseif jam_choice == 2
%     name = 'Gauss';
%     figure(1)
%     yyaxis left;
%     plot(gauss_percent,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(gauss_percent,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM (%)')
%     title('Gauss - %')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_percent_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
%     figure(2)
%     yyaxis left;
%     plot(gauss_dB,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(gauss_dB,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM dB')
%     title('Gauss - dB')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_dB_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
% elseif jam_choice == 3
%     name = 'Sin';
%     figure(1)
%     yyaxis left;
%     plot(sine_percent,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(sine_percent,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM (%)')
%     title('Sine - %')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_percent_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
%     figure(2)
%     yyaxis left;
%     plot(sine_dB,jam_power,'r*')
%     ylabel('Jamming Power (W)')
%     yyaxis right;
%     plot(sine_dB,jam_distance,'bo')
%     ylabel('Jamming Distance (m)')
%     xlabel('EVM dB')
%     title('Sine - dB')
% 
%     if img_save == 1
%         folderPath = 'Z:\Kaarmukilan\img\';
%         fileName = sprintf('EVM_dB_%s.jpg',name);
%         fullPath = fullfile(folderPath, fileName);
%         saveas(gcf, fullPath);
%     end
% 
% end
% 
