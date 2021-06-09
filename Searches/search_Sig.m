% Function to search through various sigmas for the alcubierre metric
<<<<<<< HEAD
spatialResolution = 1;
spatialExtent = [100,100,100];
R = 10;
R = R/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig(1) = 0.001;
=======
spatialResolution = 0.5;
WorldSize = 10;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = linspace(0.1,4,30);
vs = 2;
>>>>>>> af02d345e81f616ee9145db19b70f8276a2bfada

%% Run numerical code
energies = [];
energiesPos = [];
Z = {};

<<<<<<< HEAD
for i = 2:100
    sig(i) = sig(i-1)*1.2;
    AM = metricGPUGet_Alcubierre(0,1,R,sig(i),gridSize);
=======
for i = 1:length(sig)
    AM = metricGPUGet_Alcubierre(0,vs,R,sig(i),gridSize);
>>>>>>> af02d345e81f616ee9145db19b70f8276a2bfada
    Z{i} = met2den(AM);
    energies(i,:,:) = den2en(Z{i});
    energiesPos(i) = den2enPos(Z{i});
end

<<<<<<< HEAD
totalEnergy = energies(:,1,1);

=======
%% Compare to analytical formula 
Range = [-spatialExtent/2 spatialExtent/2];

E = zeros(1,length(sig));
for i = 1:length(sig)
   E(i) = Analytic_Alcubierre_Energy(sig(i),vs,R_input,Range,Range,Range);
end

%% Plot results
>>>>>>> af02d345e81f616ee9145db19b70f8276a2bfada
% figure()
% plot(sig,energiesPos);
% ylim([0 max(energiesPos)])
figure()
<<<<<<< HEAD
plot(sig(2:end),totalEnergy(2:end))
% ylim([min(energies(:,1,1)) 0])
=======
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

>>>>>>> af02d345e81f616ee9145db19b70f8276a2bfada
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
<<<<<<< HEAD
% ylim([min(energies(:,1,2)) 0])
=======
% ylim([min(energies(:,1,2)) 0])

>>>>>>> af02d345e81f616ee9145db19b70f8276a2bfada
