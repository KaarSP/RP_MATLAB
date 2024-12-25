% Load or initialize the IQ dataset
% Assuming `IQ_data` is a complex-valued matrix of size 293 x (5*10^5)
load("../../dataset/w10.mat");
% load('NO_jam.mat')
%%
no_jam = Nojamming(1:100000);
% gauss = IQ_data.Gaussian;
% sine = IQ_data.Sine;

% Parameters
num_samples = size(no_jam, 2); % Total number of samples per channel
window_size = 10; % Sliding window size for dynamic SNR calculation

% Preallocate arrays
SNR_dynamic = zeros(size(no_jam, 1), floor(num_samples / window_size));
SNR_static = zeros(size(no_jam, 1), 1);

% Process each channel independently
for channel = 1%:size(no_jam, 1)
    % Extract the IQ samples for the current channel
    IQ_channel = no_jam(channel, :);
    
    % Calculate amplitude of each IQ pair
    amplitudes = abs(IQ_channel);
    
    % Dynamic SNR calculation with a sliding window
    for k = 1:floor(num_samples / window_size)
        % Get the current window
        window_start = (k - 1) * window_size + 1;
        window_end = k * window_size;
        window_data = amplitudes(window_start:window_end);
        
        % Calculate mean and standard deviation for the current window
        mean_amp = mean(window_data);
        std_dev = std(window_data);
        
        % Calculate SNR for the window
        SNR_dynamic(channel, k) = 20 * log10(mean_amp / std_dev); % SNR in dB
    end
    
    % Static SNR calculation over the entire dataset
    mean_amp_static = mean(amplitudes);
    std_dev_static = std(amplitudes);
    SNR_static(channel) = 20 * log10(mean_amp_static / std_dev_static); % SNR in dB
end

% Plot the results
figure;
for channel = 1%:size(no_jam, 1)
    % subplot(ceil(sqrt(size(no_jam, 1))), ceil(sqrt(size(no_jam, 1))), channel);
    plot(SNR_dynamic(channel, :));
    title(['Channel ', num2str(channel), ' SNR']);
    xlabel('Window Index');
    ylabel('SNR (dB)');
end

% Static SNR display
disp('Static SNR for each channel:');
disp(SNR_static);
