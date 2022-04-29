%% Params
vs = 2;
R = 20;
sigma = 0.2;
maxGrid = [99, 99, 99];

%% Single Time Step
timeSteps = 1;
zsStart = -vs*(timeSteps-1)/2;

AM = metricGet_Alcubierre_time(zsStart,vs,R,sigma,maxGrid,timeSteps);

metricGPU = {};
metric = AM;
for i = 1:4
    for j = 1:4
        metricGPU{i,j} = gpuArray(metric{i,j});
    end
end
enDenGPU = met2den(metricGPU);
for i = 1:4
    for j = 1:4
        enDenS{i,j} = gather(enDenGPU{i,j});
    end
end
fprintf("Completed Single Time Step Run.\n")


%% Multiple Time Steps
timeSteps = 11;
zsStart = -vs*(timeSteps-1)/2;

AM = metricGet_Alcubierre_time(zsStart,vs,R,sigma,maxGrid,timeSteps);


metricGPU = {};
metric = AM;
for i = 1:4
    for j = 1:4
        metricGPU{i,j} = gpuArray(metric{i,j});
    end
end
enDenGPU = met2den(metricGPU);
for i = 1:4
    for j = 1:4
        enDenM{i,j} = gather(enDenGPU{i,j});
    end
end
fprintf("Completed Multiple Time Steps Run.\n")