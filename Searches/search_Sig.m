% Function to search through various sigmas for the alcubierre metric
spatialResolution = 1;
spatialExtent = [100,100,100];
R = 10;
R = R/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig(1) = 0.001;

energies = [];
energiesPos = [];

Z = {};

for i = 2:100
    sig(i) = sig(i-1)*1.2;
    AM = metricGPUGet_Alcubierre(0,1,R,sig(i),gridSize);
    Z{i} = met2den(AM);
    energies(i,:,:) = den2en(Z{i});
    energiesPos(i) = den2enPos(Z{i});
end

totalEnergy = energies(:,1,1);

% figure()
% plot(sig,energiesPos);
% ylim([0 max(energiesPos)])
figure()
plot(sig(2:end),totalEnergy(2:end))
% ylim([min(energies(:,1,1)) 0])
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