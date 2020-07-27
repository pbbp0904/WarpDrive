function [metricEnergy, metricMaxDen] = calcTotEnMaxDen(energyDensity)
    energyDensity = energyDensity{1,1};
    metricEnergy = sum(sum(sum(abs(energyDensity))));
    metricMaxDen = max(max(max(abs(energyDensity))));
end
