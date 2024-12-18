load("../../dataset/w10.mat")

%%
close all
n = 145000000;

figure
no_jam1 = Nojamming(1:n,:);
no_jam = Nojamming(1:n,:)./max(abs(Nojamming));
gauss = Gaussian(1:n,:)./max(abs(Gaussian));
sin = Sine(1:n,:)./max(abs(Sine));
plot(no_jam(:,1),no_jam(:,2),'r.')
hold on
plot(gauss(:,1),gauss(:,2),'g.')
hold on
plot(sin(:,1),sin(:,2),'b.')
legend('No jam', 'Gaussian','Sine')