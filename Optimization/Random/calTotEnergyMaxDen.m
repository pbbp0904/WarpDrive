function [metricEnergy, metricMaxDen] = calTotEnergyMaxDen(energyDensity)

metricEnergy = sum(sum(sum(abs(energyDensity))));

metricMaxDen = max(max(max(abs(energyDensity))));

end