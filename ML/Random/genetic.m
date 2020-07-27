% Starting Params
zDim = 100;
rDim = 50;
learningRate = 1;
maxTrain = 1000000000;

innerR = 20;

initialScalar = 0.25;
adjustmentScalar = 0.001;

%initialMetric = rand(1,1,rDim,zDim)*initialScalar-1;
metricCyl_Alcubierre
initialMetric = AM{1,1};


metric{1} = initialMetric;
specs = [];

%%%% Calculate Energy Density
energyDensity = calcDen(metric{1});

%%%% Assess fitness
% Height and Smoothness of inner area
[metricHeight, metricSmoothness] = calHeightSmoothness(metric{1},innerR);
% Total Energy and Max Energy Density
[metricEnergy, metricMaxDen] = calTotEnergyMaxDen(energyDensity);
specs(1,:) = [metricHeight, metricSmoothness, metricEnergy, metricMaxDen];
metricFitness(1) = specs(1,1)*specs(1,2)/(specs(1,3)*specs(1,4));
fprintf('Iter: %4i, Fit: %.8f, Height: %.8f, Smooth: %.8f, Energy: %.8f, MaxDen: %.8f \n',1,metricFitness(1),specs(1,1),specs(1,2),specs(1,3),specs(1,4));


% Training Loop
i = 2;
while i < maxTrain
    %%%% Create random adjustment metric
    adjustmentMetric = (rand(1,1,rDim,zDim)-0.5)*adjustmentScalar;
    
    %%%% Calculate Energy Density
    testMetric = metric{i-1} + adjustmentMetric;
    energyDensity = calcDen(testMetric);
    
    %%%% Assess fitness
    % Height and Smoothness of inner area
    [metricHeight, metricSmoothness] = calHeightSmoothness(testMetric,innerR);
    % Total Energy and Max Energy Density
    [metricEnergy, metricMaxDen] = calTotEnergyMaxDen(energyDensity);
    specs(i,:) = [metricHeight, metricSmoothness, metricEnergy, metricMaxDen];
    metricFitness(i) = specs(i,1)*specs(i,2)/(specs(i,3)*specs(i,4));
    
    %%%% Create adjusted metric
    metricRelFitness = metricFitness(i)-metricFitness(i-1);
    
    if metricRelFitness > 0
        metric{i} = metric{i-1} + adjustmentMetric*learningRate;
        fprintf('Iter: %4i, Fit: %.8f, Height: %.8f, Smooth: %.8f, Energy: %.8f, MaxDen: %.8f \n',i,metricFitness(i),specs(i,1),specs(i,2),specs(i,3),specs(i,4));
        
        if mod(i,100) == 0
            theTime = string(round(now));
            save(strcat(num2str(i),"_",theTime),'adjustmentScalar', 'initialMetric', 'initialScalar', 'innerR', 'learningRate', 'maxRGrid', 'maxTrain', 'maxZGrid', 'metric', 'metricFitness', 'rDim', 'sigma', 'specs', 'theTime', 'vs', 'z', 'zDim', 'zs','-v7.3')
        end
        i = i + 1;
    end

%     j = 1;
%     while metricRelFitness > 0
%         testMetric = metric;
%         energyDensity = calcDen(testMetric);
%     
%         %%%% Assess fitness
%         % Height and Smoothness of inner area
%         [metricHeight, metricSmoothness] = calHeightSmoothness(testMetric,innerR);
%         % Total Energy and Max Energy Density
%         [metricEnergy, metricMaxDen] = calTotEnergyMaxDen(energyDensity);
%         specs(i,:) = [metricHeight, metricSmoothness, metricEnergy, metricMaxDen];
% 
%         %%%% Create adjusted metric
%         metricRelFitness = (specs(i,1)-specs(i-1,1))*(specs(i,2)-specs(i-1,2))-(specs(i,3)-specs(i-1,3))*(specs(i,4)-specs(i-1,4));
%         metricFitness(i) = specs(i,1)*specs(i,2)+specs(i,3)*specs(i,4);
%         metricFitness(i)
%         if metricRelFitness > 0
%             metric = metric + adjustmentMetric*learningRate*j;
%         end
%         j = j + 1;
%     end
end

