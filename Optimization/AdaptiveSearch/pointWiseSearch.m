%%%% Starting Params
% Z Dimension Size
zDim = 16;
% R Dimension Size
rDim = 20;
% Plateau Radius
innerR = 6;
% Plateau z depth
depth = 2;
% Plateau Scale
sizeScale = 2;
% Plateau donut offset from axis
offset = 20;
% Plateau Height, This is equivilent to the apparent warp velocity
goalHeight = 2;
% XYZ Padding
padding = 3;
% Z Symmetry
zSym = 0;

% Max passes for one adjustment scalar
maxLoop = 1000000000;
% Max number of decreases of adjustment scalar
maxIter = 6;

% Starting magnitude of adjustment scalar
initialAdjustmentScalar = goalHeight/5;
% Randomness in adjustment scalar value
randomAd = 0;

% Try to use GPU or not
tryGPU = 1;

% Use slicing
useSlicing = 1;
% Slice distance
sliceDistance = 5;


%%%% Setup
% Makes the initial shift matrix with the plateau
% also computes the points inside the plateau that the interation should ignore

%[shiftMatrixStart, plateauPoints] = makeAlcubierreShiftMatrixPW(rDim,zDim,innerR,goalHeight,0.3);
%[shiftMatrixStart, plateauPoints] = makeExponentialShiftMatrixPW(rDim,zDim,innerR,goalHeight);
%shiftMatrixStart = round(shiftMatrixStart,1);
%[shiftMatrixStart, plateauPoints] = makeInitialShiftMatrixPW(rDim,zDim,innerR,goalHeight);
[shiftMatrixStart, plateauPoints] = makeCylindricalShiftMatrixPW(rDim,zDim,innerR,depth,goalHeight);
%[shiftMatrixStart, plateauPoints] = makeDonutShiftMatrixPW(rDim,zDim,innerR,depth,offset,goalHeight);
%[shiftMatrixStart, plateauPoints] = makeStreamlineShiftMatrixPW(rDim,zDim,sizeScale,goalHeight);

%[X, Y] = meshgrid(1:30,1:60);
%[Xq, Yq] = meshgrid(1:29/59:30,1:59/119:60);
%shiftMatrixStart = interp2(X,Y,shiftMatrix',Xq,Yq)';

% Point shift matrix
% shiftMatrixStart = zeros(rDim,zDim);
% plateauPoints = [1,round((zDim+1)/2)];
% shiftMatrixStart(1,round((zDim+1)/2)) = goalHeight;

% Make sure desired points are at the goalHeight
for i = 1:length(plateauPoints)
    shiftMatrixStart(plateauPoints(i,1),plateauPoints(i,2)) = goalHeight;
end

% drawWarpFieldPW(shiftMatrixStart)
% pause

clear RunData
rng('default')
format long
tic

% Save startup values
RunData.zDim = zDim;
RunData.rDim = rDim;
RunData.padding = padding;
RunData.zSym = zSym;
RunData.randomAd = randomAd;
RunData.maxLoop = maxLoop;
RunData.maxIter = maxIter;
RunData.innerR = innerR;
RunData.depth = depth;
RunData.offset = offset;
RunData.sizeScale = sizeScale;
RunData.goalHeight = goalHeight;
RunData.initialAdjustmentScalar = initialAdjustmentScalar;
RunData.tryGPU = tryGPU;
RunData.plateauPoints = plateauPoints;

saveIndex = 1;
validData = 1;

shiftMatrix = shiftMatrixStart;
adjustmentScalar = -initialAdjustmentScalar;

% Update State
metric = makeMetricPW(shiftMatrix, padding);
energyDensity = calcEnDenPW(metric,tryGPU);
[energyPos, energyNeg] = calcTotalEnergyPW(energyDensity);
totalEnergy = abs(energyPos) + abs(energyNeg);

% Save State
RunData.shiftMatricies{saveIndex} = shiftMatrix;
RunData.totalPosEnergies{saveIndex} = energyPos;
RunData.totalNegEnergies{saveIndex} = energyNeg;
RunData.totalEnergies{saveIndex} = totalEnergy;
RunData.rounds{saveIndex} = 1;
RunData.iteration{saveIndex} = 1;
RunData.pointChanged{saveIndex} = [0,0];
RunData.useSlicing{saveIndex} = useSlicing;
RunData.sliceDistance{saveIndex} = sliceDistance;
RunData.validData{saveIndex} = 1;
RunData.timeStamp{saveIndex} = toc;
saveIndex = saveIndex + 1;


%%%% Begin iteration
for rounds = 1:maxIter
    % Flips sign and divides by sqrt(2) every round
    adjustmentScalar = -adjustmentScalar/sqrt(2);

    fprintf('Iter: %2i-%2i, Energy: %.8e, AdScalar: %.4f\n',rounds,1,totalEnergy,adjustmentScalar);
    drawWarpFieldPW(shiftMatrix)

    % Multipass Loop
    i = 1;
    while i < maxLoop
        failTracker = 0;
        oldShiftMatrix = shiftMatrix;
        
        % Calculate valid places to build
        % Calculate neighbors of all non-zero points in the shiftMatrix
        % but outside the plateau radius
        f = ones(3);
        neighbors = abs(conv2(shiftMatrix,f,'same'))>0;
        validBuildPoints = [];
        [validBuildPoints(:,1),validBuildPoints(:,2)] = ind2sub(size(shiftMatrix),find(neighbors));
        validBuildPoints = setdiff(validBuildPoints,plateauPoints,'rows');
        
        
        %%%% Begin one pass of all valid points to build
        for j = randperm(length(validBuildPoints))
        %for j = 1:length(validBuildPoints)
            r = validBuildPoints(j,1);
            z = validBuildPoints(j,2);
            if abs(shiftMatrix(r,z) + adjustmentScalar) <= goalHeight
                
                % Create temporary shift matrix
                tempShiftMatrix = shiftMatrix;
                
                % Add adjustment scalar to temporary shift matrix
                rVar = randomAd*(rand()-0.5)+1;
                tempShiftMatrix(r,z) = tempShiftMatrix(r,z) + adjustmentScalar*(rVar);
                if zSym && z~=zDim-z+1
                    tempShiftMatrix(r,zDim-z+1) = tempShiftMatrix(r,zDim-z+1) + adjustmentScalar*(rVar);
                end
                
                % Check if the point is close to the edge of the space
                if rDim-r <= sliceDistance || zDim-z <= sliceDistance || z <= sliceDistance
                    closeToEdge = 1;
                else
                    closeToEdge = 0;
                end
                
                % If the point is not close to the edge, the space can be
                % sliced for more efficient calculation
                if ~closeToEdge && useSlicing
                    
                    slicedPadding = 0;
                    if zSym && z~=zDim-z+1
                        if z < zDim-z
                            slicedShiftMatrix = shiftMatrix(1:r+sliceDistance,z-sliceDistance:zDim-z+sliceDistance);
                            slicedTempShiftMatrix = tempShiftMatrix(1:r+sliceDistance,z-sliceDistance:zDim-z+sliceDistance);
                        else
                            slicedShiftMatrix = shiftMatrix(1:r+sliceDistance,zDim-z-sliceDistance:z+sliceDistance);
                            slicedTempShiftMatrix = tempShiftMatrix(1:r+sliceDistance,zDim-z-sliceDistance:z+sliceDistance);
                        end
                    else
                        slicedShiftMatrix = shiftMatrix(1:r+sliceDistance,z-sliceDistance:z+sliceDistance);
                        slicedTempShiftMatrix = tempShiftMatrix(1:r+sliceDistance,z-sliceDistance:z+sliceDistance);
                    end
                else
                    slicedPadding = padding;
                    slicedShiftMatrix = shiftMatrix;
                    slicedTempShiftMatrix = tempShiftMatrix;
                end
                
                % Calculate positive and negative energy for old and new sliced regions
                slicedMetric = makeMetricPW(slicedShiftMatrix, slicedPadding);
                slicedTempMetric = makeMetricPW(slicedTempShiftMatrix, slicedPadding);
                
                slicedEnergyDensity = calcEnDenPW(slicedMetric,tryGPU);
                slicedTempEnergyDensity = calcEnDenPW(slicedTempMetric,tryGPU);
                
                [slicedEnergyPos, slicedEnergyNeg] = calcTotalEnergyPW(slicedEnergyDensity);
                [slicedTempEnergyPos, slicedTempEnergyNeg] = calcTotalEnergyPW(slicedTempEnergyDensity);
                
                slicedTotalEnergy = abs(slicedEnergyPos) + abs(slicedEnergyNeg);
                slicedTempTotalEnergy = abs(slicedTempEnergyPos) + abs(slicedTempEnergyNeg);
                
                % Check if the energy in the region is now less
                if slicedTempTotalEnergy < slicedTotalEnergy
                    energyReduction = 1;
%                     disp("")
%                     disp(totalEnergy-(slicedTotalEnergy-slicedTempTotalEnergy))
%                     disp("")
%                     % Compute full region every pass
%                     metric = makeMetricPW(tempShiftMatrix, padding);
%                     energyDensity = calcEnDenPW(metric, tryGPU);
%                     [energyPosCheck, energyNegCheck] = calcTotalEnergyPW(energyDensity);
%                     totalEnergyCheck = abs(energyPosCheck) + abs(energyNegCheck);
%                     disp(totalEnergyCheck)
%                     disp("")
%                     disp(totalEnergyCheck-(totalEnergy-(slicedTotalEnergy-slicedTempTotalEnergy)))
%                     disp("")
%                     pause(1)
                else
                    energyReduction = 0;
                end
                
                
                % If the energy in the region is now less, update the shift
                % matrix and the total energy and save the results
                if energyReduction

                    % Update State
                    shiftMatrix = tempShiftMatrix;
                    energyPos = energyPos-(abs(slicedEnergyPos)-abs(slicedTempEnergyPos));
                    energyNeg = energyNeg-(abs(slicedEnergyNeg)-abs(slicedTempEnergyNeg));
                    totalEnergy = energyPos+energyNeg;

                    % Save State
                    RunData.shiftMatricies{saveIndex} = shiftMatrix;
                    RunData.totalPosEnergies{saveIndex} = energyPos;
                    RunData.totalNegEnergies{saveIndex} = energyNeg;
                    RunData.totalEnergies{saveIndex} = totalEnergy;
                    RunData.rounds{saveIndex} = rounds;
                    RunData.iteration{saveIndex} = i+1;
                    RunData.pointChanged{saveIndex} = [r,z];
                    RunData.useSlicing{saveIndex} = useSlicing;
                    RunData.sliceDistance{saveIndex} = sliceDistance;
                    RunData.validData{saveIndex} = validData;
                    RunData.timeStamp{saveIndex} = toc;
                    saveIndex = saveIndex + 1;

                    % Print changed point
                    fprintf(repmat('\b',1,failTracker))
                    fprintf('Built Point At: %4i, %4i      Energy Estimate: %.8e \n',r,z,totalEnergy);
                    failTracker = 0;
                else
                    fprintf('.')
                    failTracker = failTracker + 1;
                end
                drawWarpFieldPW(shiftMatrix)
            end
        end
        
        
        % Display Graph
        drawWarpFieldPW(shiftMatrix)
        
        % Compute full region every pass
        metric = makeMetricPW(shiftMatrix, padding);
        energyDensity = calcEnDenPW(metric, tryGPU);
        [energyPosCheck, energyNegCheck] = calcTotalEnergyPW(energyDensity);
        totalEnergyCheck = abs(energyPosCheck) + abs(energyNegCheck);

        % Update State
        energyPos = energyPosCheck;
        energyNeg = energyNegCheck;
        totalEnergy = totalEnergyCheck;

        % Save State
        RunData.shiftMatricies{saveIndex} = shiftMatrix;
        RunData.totalPosEnergies{saveIndex} = energyPos;
        RunData.totalNegEnergies{saveIndex} = energyNeg;
        RunData.totalEnergies{saveIndex} = totalEnergy;
        RunData.rounds{saveIndex} = rounds;
        RunData.iteration{saveIndex} = i+1;
        RunData.pointChanged{saveIndex} = [0,0];
        RunData.useSlicing{saveIndex} = useSlicing;
        RunData.sliceDistance{saveIndex} = sliceDistance;
        RunData.validData{saveIndex} = validData;
        RunData.timeStamp{saveIndex} = toc;
        saveIndex = saveIndex + 1;
        
        % Print iteration info
        fprintf(repmat('\b',1,failTracker))
        fprintf('\nIter: %2i-%2i, Energy: %.8e, AdScalar: %.8f, Slicing Error: %.4e\n\n',rounds,i+1,totalEnergy,adjustmentScalar,RunData.totalEnergies{saveIndex-1}-RunData.totalEnergies{saveIndex-2});
        % If no point is changed in a pass, break to the next round
        if shiftMatrix==oldShiftMatrix
            break
        end
        i = i + 1;
    end
    
    % Save RunData every round
    save(strcat("RunData-",num2str(rounds),"-",num2str(depth),'z','-',num2str(innerR),'r','-',num2str(goalHeight),'v.mat'),"RunData")
    
end

drawWarpFieldPW(shiftMatrix)


