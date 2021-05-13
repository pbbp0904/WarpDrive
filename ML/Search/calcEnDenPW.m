function enDen = calcEnDenPW(metric)
    for i = 1:4
        for j = 1:4
            metricGPU{i,j} = metric{i,j};
        end
    end
    enDen = met2den(metricGPU);
end

