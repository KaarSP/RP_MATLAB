clc
% clear
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

img = 10;  % Number of images to be considered
k2 = 5*(10^5);
k1 = img*5*(10^5);

% received_IQ = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2));
rx_signal = complex(IQ_data(1:k1,1),IQ_data(1:k1,2));

imageSel = 100;             % Selected Image
samplesPerImage = 5*(10^5); % Samples per image

startIndex = (imageSel - 1) * samplesPerImage + 1;
endIndex = imageSel * samplesPerImage;

receivedIQ = complex(Nojamming(startIndex:endIndex,1),Nojamming(startIndex:endIndex,2));

% Estimation of the transmitted sequence from No jamming scenario
transmitSeq = transmitSeqEstimate(receivedIQ);
transmit_bits = real(transmitSeq) > 0;
N = length(transmitSeq);

%% Parameters
% N = 2048;  % Repeating sequence length
% M = 10 * N; % Total received symbols (Assumption)
% 
% % Simulate a random BPSK sequence with a repeating period of 2048
% bits = randi([0 1], N, 1);  
% bpsk_symbols = 2 * bits - 1;  % BPSK modulation (0 → -1, 1 → +1)
% tx_signal = repmat(bpsk_symbols, ceil(M/N), 1); % Repeating transmission

% % Simulate channel effect (e.g., phase shift, AWGN)
% theta = pi/6;  % Unknown phase offset
% rx_signal = tx_signal .* exp(1j * theta) + 0.1 * (randn(size(tx_signal)) + 1j * randn(size(tx_signal)));

%% Extract I/Q Components
I = real(rx_signal);
Q = imag(rx_signal);
received_magnitude = abs(rx_signal);  % Magnitude of received signal

%% Autocorrelation-Based Periodicity Estimation
[autocorr_vals, lags] = xcorr(received_magnitude, 'unbiased');
[~, peak_locs] = findpeaks(autocorr_vals, 'MinPeakDistance', N/2);

% Estimated periodicity (should be close to 2048)
estimated_period = median(diff(lags(peak_locs)));
fprintf('Estimated period of repeating sequence: %d\n', estimated_period);

%% Eigenvalue Decomposition for Blind Estimation
R = (rx_signal * rx_signal') / length(rx_signal); % Sample covariance matrix
[eig_vecs, eig_vals] = eig(R);
eig_vals = diag(eig_vals);
[~, idx] = sort(eig_vals, 'descend');
signal_subspace = eig_vecs(:, idx(1:1)); % Dominant eigenvector

% Project received signal onto estimated subspace
proj_signal = real(rx_signal) * signal_subspace;

%% Blind Phase Estimation
phase_est = angle(mean(rx_signal .* conj(proj_signal)));
rx_corrected = rx_signal * exp(-1j * phase_est); % Phase correction

%% Symbol Decision: BPSK Demodulation
rx_bits = real(rx_corrected) > 0;

%% Find Optimal Bit Alignment Using Cross-Correlation
bit_error_counts = inf; % Initialize error count to a large value
best_shift = 0;

for shift = 0:N-1
    ref_bits = circshift(transmit_bits, shift); % Shift reference bits
    errors = sum(rx_bits(1:N) ~= ref_bits); % Count errors
    if errors < bit_error_counts
        bit_error_counts = errors;
        best_shift = shift;
    end
end

%% Compute BER
BER = bit_error_counts / N;
fprintf('Optimal Bit Shift: %d\n', best_shift);
fprintf('BER: %e\n', BER);

%% Display Results
figure;
subplot(3,1,1);
plot(real(rx_signal(1:500)), 'r'); hold on;
plot(imag(rx_signal(1:500)), 'b');
title('Received IQ Data (First 500 Samples)');
xlabel('Sample Index'); ylabel('Amplitude');
legend('I Component', 'Q Component');

subplot(3,1,2);
plot(lags, autocorr_vals);
title('Autocorrelation of Received Signal');
xlabel('Lags'); ylabel('Correlation');

subplot(3,1,3);
stem(rx_bits(1:100), 'filled');
title('Recovered BPSK Bits (First 100 Samples)');
xlabel('Sample Index'); ylabel('Bit Value');

fprintf('Blind estimation complete. BER computed.\n');
