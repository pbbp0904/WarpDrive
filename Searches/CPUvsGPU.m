cpuTimes = [];
gpuTimes = [];
gridRange = [1:30,32,34,36,38,40,42,44,46,48,50,54,58,62,66,70,74,78,82,86,90,94];

padding = 3;
gridSize = (gridRange+padding).*2;
NumOfGridPoints = ((gridRange+padding).*2).^3;

for i = gridRange
    [cSM, points] = makeInitialShiftMatrixPW(i,2*i,floor(i/2),1);
    
    cM = makeMetricPW(cSM, padding);
    
    useGPU = 0;
    tic
    cED = calcEnDenPW(cM,useGPU);
    cpuTimes(round(i)) = toc;
    
    useGPU = 1;
    gpuDevice(1);
    tic
    cED = calcEnDenPW(cM,useGPU);
    gpuTimes(round(i)) = toc;
    
    
    fprintf("Done with %i\n",i)
end

[~,crossoverPoint] = min(abs(cpuTimes-gpuTimes));
crossoverGridSize = gridSize(crossoverPoint);
crossoverNumOfGridPoints = NumOfGridPoints(crossoverPoint);

maxGPUGridSize = max(gridSize);
maxGPUNumOfPoints = max(NumOfGridPoints);

    
    