%%%% Starting Params
% Z Dimension Size
zDim = 50;
% R Dimension Size
rDim = 100;
% Plateau Radius
innerR = 10;
% Plateau Height, This is equivilent to the apparent warp velocity
goalHeight = 10;
% XYZ Padding
padding = 3;
% Z Symmetry
zSym = 1;

% Max passes for one adjustment scalar
maxLoop = 1000000000;
% Max number of decreases of adjustment scalar
maxIter = 16;

% Starting magnitude of adjustment scalar
initialAdjustmentScalar = goalHeight/10;
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
% also computes the points inside the radius that the interation should ignore

[shiftMatrixStart, plateauPoints] = makeExponentialShiftMatrixPW(rDim,zDim,innerR,goalHeight);
shiftMatrixStart = round(shiftMatrixStart,3);
%[shiftMatrixStart, plateauPoints] = makeInitialShiftMatrixPW(rDim,zDim,innerR,goalHeight);

%[X, Y] = meshgrid(1:30,1:60);
%[Xq, Yq] = meshgrid(1:29/59:30,1:59/119:60);
%shiftMatrixStart = interp2(X,Y,shiftMatrix',Xq,Yq)';

% Make sure desired points are at the goalHeight
for i = 1:length(plateauPoints)
    shiftMatrixStart(plateauPoints(i,1),plateauPoints(i,2)) = goalHeight;
end

clear RunData
rng('default')

% Save startup values
RunData.zDim = zDim;
RunData.rDim = rDim;
RunData.padding = padding;
RunData.zSym = zSym;
RunData.randomAd = randomAd;
RunData.maxLoop = maxLoop;
RunData.maxIter = maxIter;
RunData.innerR = innerR;
RunData.goalHeight = goalHeight;
RunData.initialAdjustmentScalar = initialAdjustmentScalar;
RunData.tryGPU = tryGPU;
RunData.useSlicing = useSlicing;
RunData.sliceDistance = sliceDistance;

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
RunData.validData{saveIndex} = 1;
saveIndex = saveIndex + 1;


%%%% Begin iteration
for rounds = 1:maxIter
    % Flips sign and divides by sqrt(2) every round
    adjustmentScalar = -adjustmentScalar/sqrt(2);

    fprintf('Iter: %2i-%2i, Energy: %.8f, AdScalar: %.4f\n',rounds,1,totalEnergy,adjustmentScalar);
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
                else
                    energyReduction = 0;
                end
                
                
                % If the energy in the region is now less, update the shift
                % matrix and the total energy and save the results
                if energyReduction
                    % Update State
                    shiftMatrix = tempShiftMatrix;
                    energyPos = energyPos-(slicedEnergyPos-slicedTempEnergyPos);
                    energyNeg = energyNeg-(slicedEnergyNeg-slicedTempEnergyNeg);
                    totalEnergy = abs(energyPos)+abs(energyNeg);

                    % Save State
                    RunData.shiftMatricies{saveIndex} = shiftMatrix;
                    RunData.totalPosEnergies{saveIndex} = energyPos;
                    RunData.totalNegEnergies{saveIndex} = energyNeg;
                    RunData.totalEnergies{saveIndex} = totalEnergy;
                    RunData.rounds{saveIndex} = rounds;
                    RunData.iteration{saveIndex} = i+1;
                    RunData.pointChanged{saveIndex} = [r,z];
                    RunData.validData{saveIndex} = validData;
                    saveIndex = saveIndex + 1;

                    % Print changed point
                    fprintf(repmat('\b',1,failTracker))
                    fprintf('Built Point At: %4i, %4i,  Energy: %.8f \n',r,z,totalEnergy);
                    failTracker = 0;
                else
                    fprintf('.')
                    failTracker = failTracker + 1;
                end
            end
        end
        
        
        % Compute full region every pass to verify data
        metric = makeMetricPW(shiftMatrix, padding);
        energyDensity = calcEnDenPW(metric, tryGPU);
        [energyPosCheck, energyNegCheck] = calcTotalEnergyPW(energyDensity);
        totalEnergyCheck = abs(energyPosCheck) + abs(energyNegCheck);

        if totalEnergyCheck ~= totalEnergy || validData == 0
            negDiff = energyNeg-energyNegCheck;
            posDiff = energyPos-energyPosCheck;
            totDiff = totalEnergy-totalEnergyCheck;
            if negDiff > 10^-8 || posDiff > 10^-8 || totDiff > 10^-8 || energyNeg < 0 || energyPos < 0 || totalEnergy < 0 || validData == 0
                fprintf("Warning Check Failed\n")
                validData = 0;
            end
        end
        

        % Display Graph
        drawWarpFieldPW(shiftMatrix)
        
        % Print iteration info
        fprintf(repmat('\b',1,failTracker))
        fprintf('Iter: %2i-%2i, Energy: %.8f, AdScalar: %.4f\n',rounds,i+1,totalEnergy,adjustmentScalar);
        
        % If no point is changed in a pass, break to the next round
        if shiftMatrix==oldShiftMatrix
            break
        end
        i = i + 1;
    end
end

drawWarpFieldPW(shiftMatrix)



