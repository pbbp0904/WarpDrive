function [metricEnergyPos, metricEnergyNeg] = calcTotalEnergyPW(energyDensity)
    energyDensity = energyDensity{1,1};
    metricEnergyPos = gather(sum(abs(energyDensity(energyDensity>0)),'all'));
    metricEnergyNeg = gather(sum(abs(energyDensity(energyDensity<0)),'all'));
end
