clc;
close all;

load("../../dataset/w10.mat")

%%
n = 10000;
no_jam = Nojamming(1:n,:);
gauss = Gaussian(1:n,:);
sin = Sine(1:n,:);

% Demodulate IQ Data - BPSK
for i = 1:n
    if no_jam(i,1) > 0
        demod_no_jam(i) = 1;
    else
        demod_no_jam(i) = 0;
    end
end

figure
plot(no_jam(:,1),no_jam(:,2),'r.')
