function enDen = calcEnDenPW(metric, tryGPU)
if tryGPU
    [a,b,c,d] = size(metric{1,1});
    numOfGridPoints = a*b*c*d;
    gpuLowerLimit =  100000;
    gpuUpperLimit = 6000000;
    if numOfGridPoints > gpuLowerLimit && numOfGridPoints < gpuUpperLimit
        useGPU = 1;
    else
        useGPU = 0;
    end
else
    useGPU = 0;
end

if useGPU
    %gpuDevice(1);
    metricGPU = {};
    for i = 1:4
        for j = 1:4
            metricGPU{i,j} = gpuArray(metric{i,j});
        end
    end
    enDenGPU = met2den(metricGPU);
    for i = 1:4
        for j = 1:4
            enDen{i,j} = gather(enDenGPU{i,j});
        end
    end
else
    enDen = met2den(metric);
end
end

