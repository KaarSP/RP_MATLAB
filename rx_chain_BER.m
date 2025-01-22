tic
% Parameters
fs = 1e6;           % Sampling rate (Hz)
modOrd = 2;         % BPSK (binary modulation)
seqLen = 256 * 8;   % Length of one repeating sequence in bits
fc = 900e3;           % Carrier frequency (Hz)
% tic
% % Load or initialize the IQ dataset
% load("../w1.mat");
% toc
% 
% % Select the type of Jamming: (1) No Jamming / (2) Gaussian / (3) Sine
% jam_choice = 2;
% if jam_choice == 1
%     IQ_data = Nojamming;
% elseif jam_choice == 2
%     IQ_data = Gaussian;
% elseif jam_choice == 3
%     IQ_data = Sine;
% end
load nojam.mat
% l = 5*(10^5);
% k1 = 5*(10^5);
% 
% received_IQ = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2)); % Taking only one image

% Step 1: Adaptive Gain Control (AGC)
normalizedIQ = received_IQ / max(abs(received_IQ)); % Normalize signal

% Step 2: Autocorrelation to Detect Repeating Pattern
autocorrResult = xcorr(real(normalizedIQ), 'biased');   % Autocorrelation of real part
[~, lag] = max(autocorrResult(seqLen:end));     % Find lag corresponding to sequence length
lag = lag + seqLen - 1;                         % Adjust lag index

% Extract one repetition of the sequence
repeatedSequence = normalizedIQ(1:lag);


figure;
plot(autocorrResult)

figure;
plot(repeatedSequence,'b.')
title('Sequence after auto-correlation')

% % Step 3: Frequency Synchronization using Costas Loop
% N = length(repeatedSequence);
% theta = 0;                  % Initialize phase
% loopFilterGain = 0.1;       % Loop filter gain
% correctedIQ = zeros(N, 1);  % To store frequency-corrected IQ samples
% phase_accumulator = 0;
% t = (0:N-1) / fs;             % Time vector
% 
% loop_gain = 0.01;      % Loop gain
% loop_bandwidth = 1e6;   % Loop bandwidth (Hz)
% % Loop filter coefficients (2nd order loop)
% alpha = loop_bandwidth * 2 / fs; % Proportional term
% beta = alpha^2;                  % Integral term
% estimated_phase = 0;   % Initial phase estimate
% 
% for n = 1:N
%     % correctedIQ(i) = repeatedSequence(i) * exp(-1j * theta);    % Frequency correction
%     % phaseError     = angle(correctedIQ(i));                     % Phase error
%     % theta          = theta + loopFilterGain * phaseError;       % Update phase
% 
%     % Generate local oscillator signals
%     lo_cos = cos(2*pi*fc*t(n) + phase_accumulator);
%     lo_sin = sin(2*pi*fc*t(n) + phase_accumulator);
% 
%     % Mix received signal with local oscillator
%     I = repeatedSequence(n) * lo_cos;
%     Q = repeatedSequence(n) * lo_sin;
% 
%     % Calculate phase error
%     phase_error = -I * Q; % BPSK phase detector
% 
%     % Update loop filter and phase accumulator
%     estimated_phase = estimated_phase + alpha * phase_error + beta * sum(phase_error);
%     phase_accumulator = phase_accumulator + estimated_phase;
% 
%     % Save outputs
%     I_out(n) = I;
%     Q_out(n) = Q;
% end

% Step 4: Constellation Decoding (BPSK Demodulation)
receivedBits = real(repeatedSequence) > 0;       % BPSK decision rule (threshold at 0)

% Step 5: BER Calculation
% Extract repeating sequence (reference sequence)
referenceBits = real(repeatedSequence) > 0; % Decode the reference sequence

% Calculate BER
bitErrors = sum(referenceBits ~= receivedBits); % Errors in bits
BER = bitErrors / length(referenceBits); % Calculate BER

% Display Results
disp(['Bit Error Rate (BER) - No Jamming Signal: ', num2str(BER)]);
toc

% return
load gauss.mat

% Step 1: Adaptive Gain Control (AGC)
normalizedIQ_gauss = received_IQ / max(abs(received_IQ)); % Normalize signal

% Step 2: Autocorrelation to Detect Repeating Pattern
autocorrResult_gauss = xcorr(real(normalizedIQ_gauss), 'biased');   % Autocorrelation of real part
[~, lag_gauss] = max(autocorrResult_gauss(seqLen:end));     % Find lag corresponding to sequence length
lag_gauss = lag_gauss + seqLen - 1;                         % Adjust lag index

% Extract one repetition of the sequence
repeatedSequence_gauss = normalizedIQ_gauss(1:lag_gauss);

% Step 4: Constellation Decoding (BPSK Demodulation)
receivedBits_gauss = real(repeatedSequence_gauss) > 0;       % BPSK decision rule (threshold at 0)

% Calculate BER
bitErrors = sum(referenceBits ~= receivedBits_gauss); % Errors in bits
BER = bitErrors / length(referenceBits); % Calculate BER

% Display Results
disp(['Bit Error Rate (BER) - Gauss Signal: ', num2str(BER)]);