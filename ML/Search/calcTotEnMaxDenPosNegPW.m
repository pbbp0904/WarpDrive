function [metricEnergyPos, metricEnergyNeg, metricMaxDenPos, metricMaxDenNeg] = calcTotEnMaxDenPosNegPW(energyDensity)
    energyDensity = energyDensity{1,1};
    metricEnergyPos = sum(sum(sum(energyDensity(energyDensity>0))));
    metricEnergyNeg = abs(sum(sum(sum(energyDensity(energyDensity<0)))));
    metricMaxDenPos = max(max(max(energyDensity(energyDensity>0))));
    metricMaxDenNeg = max(max(max(abs(energyDensity(energyDensity<0)))));
end
