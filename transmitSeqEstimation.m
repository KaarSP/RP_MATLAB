clc
clear
close all

load nojam.mat

% Compute autocorrelation
autoCorr = xcorr(real(received_IQ));

% Focus on positive lags
positiveLags = autoCorr(length(received_IQ):end);

[~, locs] = findpeaks(positiveLags, 'MinPeakHeight', max(positiveLags)*0.8);
len_RepeatSeq = locs(1)-1; % Length of the repeating sequence

% Extract the repeating sequence
repeatSeq = zeros(len_RepeatSeq,length(locs));
for i = 1:length(locs)
    repeatSeq(:,i) = real(received_IQ((i-1)*len_RepeatSeq+1:i*len_RepeatSeq));
end

% Estimated transmit sequence
transmitSeq = mean(repeatSeq, 2); 

k = 500;
plot((repeatSeq(1:k,1)),'c.')
hold on
plot((repeatSeq(1:k,2)),'r.')
hold on
plot((repeatSeq(1:k,3)),'g.')
hold on
plot((repeatSeq(1:k,4)),'k.')
hold on
plot(transmitSeq(1:k),'b*')
legend('Sequence 1','Sequence 2','Sequence 3','Sequence 4','Average Sequence');
title('Average Transmit Sequence')
save transmitSeqEstimate_w1.mat transmitSeq