function fitness = calcFitPW(currentShiftMatrix, currentEnDen, keepoutRadius, goalHeight)
    % Height and Smoothness of inner area
    %[metricHeight, metricSmoothness] = calcHeightSmoothPW(currentShiftMatrix,keepoutRadius,goalHeight);
    % Total Energy and Max Energy Density
    %[metricEnergy, metricMaxDen] = calcTotEnMaxDenPW(currentEnDen);
    [metricEnergyPos, metricEnergyNeg, metricMaxDenPos, metricMaxDenNeg] = calcTotEnMaxDenPosNegPW(currentEnDen);
    
    fitness = 1/(metricEnergyPos+10*metricEnergyNeg);
    %fitness = 1/(metricEnergy*metricMaxDen);
    %fitness = metricHeight*metricSmoothness/(metricEnergy*metricMaxDen);
end