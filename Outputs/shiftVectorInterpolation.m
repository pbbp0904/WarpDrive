load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Spheres\RunData-6-14z-14r-2v.mat')
RunDataA = RunData;
shiftMatrixA = RunDataA.shiftMatricies{end};

load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\Spheres\RunData-6-0z-14r-2v.mat')
RunDataB = RunData;
shiftMatrixB = RunDataB.shiftMatricies{end};


%%
imax = 10;
irange = 0:imax;
for i = irange
    shiftMatrix = (1-i/imax) .* shiftMatrixA + i/imax .* shiftMatrixB;
    metric = makeMetricPW(shiftMatrix,3);
    Z = calcEnDenPW(metric,1);
    enDen(i+1) = sum(squeeze(Z{1,1}),'all');
end


%%

plot(irange,enDen)