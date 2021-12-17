function [fitness] = testShiftMatrix(shiftMatrix, innerR, goalHeight, padding)
close all
[h,w] = size(shiftMatrix);
cSM = shiftMatrix;

% Update State
cM = makeMetricPW(cSM, padding);
cED = calcEnDenPW(cM);
cF = calcFitPW(cSM, cED, innerR, goalHeight);
fprintf('Fit: %.8f\n',cF);
drawWarpFieldPW(cSM)
Q = [];
Q(:,:,:) = abs(cED{4,4}(1,:,:,:));
sliceomatic(Q);

fitness = cF;

[x,y,z] = meshgrid(1:w+2*padding,1:w+2*padding,1:w+2*padding);
meanZ = mean(cED{1,4}(1,:,:,:)./sign(cED{1,1}(1,:,:,:)+0.0000000000006),'all')
figure()
quiver3(x,y,z,squeeze(cED{1,2}(1,:,:,:)./sign(cED{1,1}(1,:,:,:))),-squeeze(cED{1,3}(1,:,:,:)./sign(cED{1,1}(1,:,:,:))),squeeze((cED{1,4}(1,:,:,:))./sign(cED{1,1}(1,:,:,:)))-0.005);
%figure()
%quiver(x,y,squeeze(cED{1,2}(1,:,:,33)./cED{1,1}(1,:,:,33)),squeeze(cED{1,3}(1,:,:,33)./cED{1,1}(1,:,:,33)))


end

