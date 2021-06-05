% Function to search through various sigmas for the alcubierre metric
spatialResolution = 0.5;
WorldSize = 10;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = linspace(0.1,4,30);
vs = 2;

%% Run numerical code
energies = [];
energiesPos = [];
Z = {};

for i = 1:length(sig)
    AM = metricGPUGet_Alcubierre(0,vs,R,sig(i),gridSize);
    Z{i} = met2den(AM);
    energies(i,:,:) = den2en(Z{i});
    energiesPos(i) = den2enPos(Z{i});
end

%% Compare to analytical formula 
Range = [-spatialExtent/2 spatialExtent/2];

E = zeros(1,length(sig));
for i = 1:length(sig)
   E(i) = Analytic_Alcubierre_Energy(sig(i),vs,R_input,Range,Range,Range);
end

%% Plot results
% figure()
% plot(sig,energiesPos);
% ylim([0 max(energiesPos)])
figure()
subplot(1,3,1)
plot(sig,energies(:,1,1))
% ylim([min(energies(:,1,1)) 0])
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [a.u.]')
title('Numerical Approach')

subplot(1,3,2)
plot(sig,E)
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [a.u.]')
title('Analytical Approach')

subplot(1,3,3)
hold on
plot(sig,energies(:,1,1))
plot(sig,E)
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [a.u.]')
title('Result Comparison')
legend('Numerical','Analytical')
box on
set(gcf,'color','w');
sgtitle(['Alcubierre Metric: R = ' num2str(R_input) ', v_s = ' num2str(vs) ', \sigma = \{' num2str(min(sig)) ', ' num2str(max(sig)) '\}, World Size = ' num2str(WorldSize) ', Res = ' num2str(spatialResolution)])

% figure()
% plot(sig,energies(:,2,2))
% %ylim([min(energies(:,2,2)) 0])
% figure()
% plot(sig,energies(:,3,3))
% ylim([0 max(energies(:,3,3))])
% figure()
% plot(sig,energies(:,4,4))
% ylim([0 max(energies(:,3,3))])
% figure()
% plot(sig,energies(:,1,2))
% ylim([min(energies(:,1,2)) 0])

