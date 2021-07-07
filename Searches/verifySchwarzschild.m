% Function to search through various radii for the Schwarzschild metric
format longg
G = 6.674*10^-11;
c = 2.99792*10^8;

spatialResolution = 1; % meters/grid point
WorldSize = 20; % meters
spatialExtent = [WorldSize,WorldSize,WorldSize];
gridSize = spatialExtent./spatialResolution;

sRadius = [0.000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1,1,10,100,1000,10000,100000,1000000,10000000,100000000];
%sRadius = [0.000000001,0.000000001,0.00000001,0.0000001,0.000001,0.00001,0.0001,0.001,0.01,0.1];

%% Run through sigmas
energiesNumerical = [];
Z = {};
E = zeros(1,length(sRadius));

for i = 1:length(sRadius)
    % Run numerical code 1
    SM = metricGet_Schwarzschild(sRadius(i),gridSize(1));
    Z{i} = met2den(SM);
    energiesNumerical(i,:,:) = sum(squeeze(Z{i}{1,1}),'all','omitnan').*spatialResolution^2;
    
    
    % Compare to analytical formula 
    E(i) = sRadius(i)*c^4/(2*G);
    fprintf("Done with R = %i\n",sRadius(i));
end



%% Plot results
figure()
hold on
plot(sRadius,abs(energiesNumerical(:,1,1)))
plot(sRadius,E)
set(gca,'Xscale','log')
set(gca,'Yscale','log')
xlabel('Schwarszchild Radius')
ylabel('Energy [J]')
legend('Numerical','Analytical')
box on
set(gcf,'color','w');
title(['Schwarzschild Metric: R = \{' num2str(min(sRadius)) ', ' num2str(max(sRadius)) '\}, World Size = ' num2str(WorldSize) ', Res = ' num2str(spatialResolution)])

energiesNumerical(1,1,1)/E(1)
