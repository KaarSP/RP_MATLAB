clc
clear
close all

load nojam.mat

% Compute autocorrelation
autoCorr = xcorr(real(received_IQ));

% Focus on positive lags
positiveLags = autoCorr(length(received_IQ):end);

% Find the first peak after lag 0 (ignoring the zero-lag peak)
[~, locs] = findpeaks(positiveLags, 'MinPeakHeight', max(positiveLags)*0.8);
repeatingStart = locs(1)-1; % This is the length of the repeating sequence

% Extract the repeating sequence
repeatingSequence1 = received_IQ(1:repeatingStart);
repeatingSequence2 = received_IQ(repeatingStart+1:2*repeatingStart);
repeatingSequence3 = received_IQ(2*repeatingStart+1:3*repeatingStart);

plot(abs(repeatingSequence1),'r.')
hold on
plot(abs(repeatingSequence2),'b.')
hold on
plot(abs(repeatingSequence3),'g.')
