function transmitSeq = transmitSeqEstimate(received_IQ)
    % Compute autocorrelation
    autoCorr = xcorr(real(received_IQ),real(received_IQ));

    % plot(aut)
    
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
end