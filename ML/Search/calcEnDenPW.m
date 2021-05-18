function enDen = calcEnDenPW(metric, useGPU)
    if useGPU
        metricGPU = {};
        for i = 1:4
            for j = 1:4
                metricGPU{i,j} = gpuArray(metric{i,j});
            end
        end
        enDen = met2den(metricGPU);
    else
        enDen = met2den(metric);
    end
end

