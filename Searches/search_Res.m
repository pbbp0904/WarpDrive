% Function to search through various resolutions for the alcubierre metric
spatialExtent = [100,100,100];
R_normal = 30;
sig_normal = 1.5*4/R_normal;
v_normal = 20;

res = 0.8:0.05:1.2;

energies = [];
energiesPos = [];


% for i = 1:length(res)
%     
%     sig = sig_normal*res(i);
%     R = R_normal/res(i);
%     gridSize = round(spatialExtent./res(i));
%     
%     AM = metricGPUGet_Alcubierre(0,1,R,sig,gridSize);
%     Z = met2den(AM);
%     energies(i,:,:) = den2en(Z);
%     energiesPos(i) = den2enPos(Z);
% end



startingRes = 0.64;
scalingFactor = 1.2;
res = [];
res(1) = startingRes;
for i = 1:5
    sig = sig_normal*res(i);
    R = R_normal/res(i);
    gridSize = round(spatialExtent./res(i))
    
    AM = metricGPUGet_Alcubierre(0,v_normal/res(i),R,sig,gridSize);
    P=[];
    A = gather(AM{1,1});
    P(:,:) = A(1,round(gridSize(1)/2),:,:);
    surf(P)
    drawnow
    Z = met2den(AM);
    energies(i,:,:) = den2en(Z);
    energiesPos(i) = den2enPos(Z);
    res(i+1) = res(i)*scalingFactor;
end
res(length(res)) = [];



N = 0;
figure()
plot(res,energiesPos.*(res).^N);
figure()
plot(res,energies(:,1,1).*(res').^N)
figure()
plot(res,energies(:,2,2).*(res').^N)
figure()
plot(res,energies(:,3,3).*(res').^N)
figure()
plot(res,energies(:,4,4).*(res').^N)
figure()
plot(res,energies(:,1,2).*(res').^N)