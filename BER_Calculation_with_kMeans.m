% Load or initialize the IQ dataset
% tic
% fileName = "../dataset/w1.mat";
% [~, fname, ~] = fileparts(fileName);
% load(fileName);
% toc

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

imageSel = 1;             % Selected Image
samplesPerImage = 5*(10^5); % Samples per image

startIndex = (imageSel - 1) * samplesPerImage + 1;
endIndex = imageSel * samplesPerImage;

receivedIQ = complex(Nojamming(startIndex:endIndex,1),Nojamming(startIndex:endIndex,2));

% Estimation of the transmitted sequence from No jamming scenario
transmitSeq = transmitSeqEstimate(receivedIQ);
transmit_bits = real(transmitSeq) > 0;

% Number of samples
N = length(transmitSeq);

img = 10;  % Number of images to be considered
k2 = 5*(10^5);
k1 = img*5*(10^5);

% received_IQ = complex(IQ_data(1+k1:l+k1,1),IQ_data(1+k1:l+k1,2));
rx_signal = complex(IQ_data(1:k1,1),IQ_data(1:k1,2));

% Step 1: Estimate bit threshold using clustering (K-means)
data_points = real(rx_signal(:));
[idx, centers] = kmeans(data_points, 2); % Clustering into 2 groups (BPSK)

% Step 2: Identify which cluster corresponds to bit 1 or 0
if centers(1) > centers(2)
    estimated_bits = (idx == 1); % Assign 1 to the cluster with a higher mean
else
    estimated_bits = (idx == 2);
end

estimate_2048 = estimated_bits(1:2048);

% Step 3: Calculate BER (assuming we have access to true bits for evaluation)
bit_errors = sum(estimate_2048 ~= transmit_bits);
BER = bit_errors / N;

% Display results
disp(['Bit Errors: ', num2str(bit_errors)]);
disp(['BER: ', num2str(BER)]);
