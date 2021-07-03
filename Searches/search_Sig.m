% Function to search through various sigmas for the alcubierre metric

spatialResolution = 1; % meters/grid point
WorldSize = 100; % meters
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 20; % meters
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = linspace(0.1,1,10);
vs = 0.001;


%% Run through sigmas
energiesNumerical = [];
energiesNumerical2 = [];
shiftMatricies = {};
shiftMatrixSlice = {};
Z = {};
Z2 = {};
Range = [-WorldSize/2 WorldSize/2];
E = zeros(1,length(sig));

for i = 1:length(sig)
    % Run numerical code #1
    %AM = metricGPUGet_Alcubierre(0,vs,R,sig(i),gridSize);
    %Z{i} = met2den(AM);
    %energiesNumerical(i,:,:) = den2en(Z{i}).*spatialResolution^2;
    
    % Run numerical code #2
    shiftMatricies{i} = makeAlcubierreShiftMatrixPW(round(gridSize(1)/2),gridSize(3),R_input,vs,sig(i));
    AM2 = makeMetricPW(shiftMatricies{i}, 3);
    Z2{i} = met2den(AM2);
    energiesNumerical2(i,:,:) = den2en(Z2{i}).*spatialResolution^2;
    
    
    shiftMatrixSlice{i} = shiftMatricies{i}(:,round(gridSize(1)/2));
    
    
    % Compare to analytical formula 
    E(i) = Analytic_Alcubierre_Energy(sig(i),vs,R_input,Range,Range,Range);
    fprintf("Done with Sig=%i\n",sig(i));
end



%% Plot results
figure()
hold on
for i = 1:length(sig)
    plot(shiftMatrixSlice{i})
end

figure()
% ylim([min(energies(:,1,1)) 0])
subplot(1,3,1)
hold on
%plot(sig,energiesNumerical(:,1,1))
plot(sig,-abs(energiesNumerical2(:,1,1)))
% ylim([min(energies(:,1,1)) 0])
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [J]')
legend('Numerical 1')
title('Numerical Approach')

subplot(1,3,2)
plot(sig,E)
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [J]')
title('Analytical Approach')

subplot(1,3,3)
hold on
%plot(sig,energiesNumerical(:,1,1))
plot(sig,-abs(energiesNumerical2(:,1,1)))
plot(sig,E)
set(gca,'Yscale','log')
xlabel('\sigma')
ylabel('Energy [J]')
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
% ylim([min(energies(:,1,2)) 0])

