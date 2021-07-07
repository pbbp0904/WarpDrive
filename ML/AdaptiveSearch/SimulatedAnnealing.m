%%%% Starting Params
% Z Dimension Size
zDim = 64;
% R Dimension Size
rDim = 64;
% Plateau Radius
innerR = 15;
% Plateau depth
depth = 16;
% Plateau Scale
sizeScale = 2;
% Plateau donut offset from axis
offset = 20;
% Plateau Height, This is equivilent to the apparent warp velocity
goalHeight = 1;
% XYZ Padding
padding = 3;
% Z Symmetry
zSym = 0;

% Max number of RunData saves
maxIter = 20;
% Max number of temperature decreases per RunData save
maxLoop = 20;

% Starting temperature
initTemperature = 0.1;

% Try to use GPU or not
tryGPU = 1;

% Use slicing
useSlicing = 1;
% Slice distance
sliceDistance = 5;


%%%% Setup
% Makes the initial shift matrix with the plateau
% also computes the points inside the plateau that the interation should ignore

%[shiftMatrixStart, plateauPoints] = makeExponentialShiftMatrixPW(rDim,zDim,innerR,goalHeight);
%shiftMatrixStart = round(shiftMatrixStart,1);
[shiftMatrixStart, plateauPoints] = makeInitialShiftMatrixPW(rDim,zDim,innerR,goalHeight);
%[shiftMatrixStart, plateauPoints] = makeCylindricalShiftMatrixPW(rDim,zDim,innerR,depth,goalHeight);
%[shiftMatrixStart, plateauPoints] = makeDonutShiftMatrixPW(rDim,zDim,innerR,depth,offset,goalHeight);
%[shiftMatrixStart, plateauPoints] = makeStreamlineShiftMatrixPW(rDim,zDim,sizeScale,goalHeight);


% Make sure desired points are at the goalHeight
for i = 1:length(plateauPoints)
    shiftMatrixStart(plateauPoints(i,1),plateauPoints(i,2)) = goalHeight;
end

clear RunData
rng('default')
format long
tic

% Save startup values
RunData.zDim = zDim;
RunData.rDim = rDim;
RunData.padding = padding;
RunData.zSym = zSym;
RunData.maxLoop = maxLoop;
RunData.maxIter = maxIter;
RunData.innerR = innerR;
RunData.depth = depth;
RunData.offset = offset;
RunData.sizeScale = sizeScale;
RunData.goalHeight = goalHeight;
RunData.tryGPU = tryGPU;
RunData.plateauPoints = plateauPoints;
RunData.initTemperature = initTemperature;

saveIndex = 1;
validData = 1;

shiftMatrix = shiftMatrixStart;

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

    fprintf('\nIter: %2i-%2i, Energy: %.8e, Temperature: %.4f\n',rounds,1,totalEnergy,initTemperature);
    drawWarpFieldPW(shiftMatrix)
    
    % Calculate valid places to build
    % Calculate neighbors of all non-zero points in the shiftMatrix
    % but outside the plateau radius
    
    validBuildPoints = [];
    allPoints = ones(size(shiftMatrix,1),size(shiftMatrix,2));
    [validBuildPoints(:,1),validBuildPoints(:,2)] = ind2sub(size(shiftMatrix),find(allPoints));
    validBuildPoints = setdiff(validBuildPoints,plateauPoints,'rows');
        

    % Multipass Loop
    for i = 1:maxLoop
        %Temperature reduction
        temperature = initTemperature - ((rounds/maxIter) * initTemperature) - ((i/maxLoop) * (1/maxIter) * initTemperature);
        oldShiftMatrix = shiftMatrix;
        
        %%%% Begin one pass of all valid points to build
        for j = randperm(length(validBuildPoints))
        %for j = 1:length(validBuildPoints)
            r = validBuildPoints(j,1);
            z = validBuildPoints(j,2);
            
            delta = (rand()-0.5)*goalHeight;
            while abs(shiftMatrix(r,z) + delta) > goalHeight
                delta = (rand()-0.5)*goalHeight;
            end

            % Create temporary shift matrix
            tempShiftMatrix = shiftMatrix;

            % Add adjustment scalar to temporary shift matrix
            tempShiftMatrix(r,z) = tempShiftMatrix(r,z) + delta;
            if zSym && z~=zDim-z+1
                tempShiftMatrix(r,zDim-z+1) = tempShiftMatrix(r,zDim-z+1) + delta;
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
                if rand() < temperature
                    energyReduction = 1; 
                else
                    energyReduction = 0;
                end
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
                fprintf('\nBuilt Point At: %4i, %4i      Energy Estimate: %.8e \n',r,z,totalEnergy);
            else
                fprintf('.')
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
        fprintf('\nIter: %2i-%2i, Energy: %.8e, Temperature: %.8f, Slicing Error: %.4e\n\n',rounds,i+1,totalEnergy,temperature,RunData.totalEnergies{saveIndex-1}-RunData.totalEnergies{saveIndex-2});
    end
    
    % Save RunData every round
    save(strcat("RunData-",num2str(rounds)),"RunData")
    
end

drawWarpFieldPW(shiftMatrix)
