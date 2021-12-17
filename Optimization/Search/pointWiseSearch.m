%%%% Starting Params
% Z Dimension Size
zDim = 50;
% R Dimension Size
rDim = 100;
% XYZ Padding
padding = 3;
% Z Symmetry
zSym = 1;
% Randomness
randomAd = 0;
% Max Training for One Adjustment Scalar
maxTrain = 1000000000;
% Plateau Radius
innerR = 10;
% Plateau Height, This is equivilent to the apparent warp velocity
goalHeight = 10;
initialAdjustmentScalar = goalHeight/2;

% Use GPU
useGPU = 1;


%%%% Setup
% Makes the initial shift matrix with the plateau
% also computes the points inside the radius that the interation should ignore



%[shiftMatrixStart, points] = makeAlcubierreShiftMatrixPW(rDim,zDim,innerR,goalHeight,1);
[shiftMatrixStart, points] = makeInitialShiftMatrixPW(rDim,zDim,innerR,goalHeight);

[X, Y] = meshgrid(1:30,1:60);
[Xq, Yq] = meshgrid(1:29/59:30,1:59/119:60);
%shiftMatrixStart = interp2(X,Y,shiftMatrix',Xq,Yq)';

for i = 1:length(points)
    shiftMatrixStart(points(i,1),points(i,2)) = goalHeight;
end
cSM = {};
cSM{1} = shiftMatrixStart;

adjustmentScalar = -initialAdjustmentScalar;

for rounds = 1:14
    % Flips sign and divides by sqrt(2) every round
    adjustmentScalar = -adjustmentScalar/sqrt(2);
    % Sets the starting shift matrix equal to the previous rounds output
    shiftMatrixStart = cSM{end};
    cSM = {};
    cM = {};
    cED = {};
    cF = [];
    
    [h,w] = size(shiftMatrixStart);
    cSM{1} = shiftMatrixStart;

    % Update State
    cM{1} = makeMetricPW(cSM{1}, padding);
    cED{1} = calcEnDenPW(cM{1},useGPU);
    cF(1) = calcFitPW(cSM{1}, cED{1}, innerR, goalHeight);
    fprintf('Iter: %2i-%2i, Fit: %.8f, AdScalar: %.4f\n',rounds,1,cF(1),adjustmentScalar);
    drawWarpFieldPW(cSM{end})


    % Training Loop
    i = 2;
    while i < maxTrain
        cSM{i} = cSM{i-1};
        cF(i) = cF(i-1);
        failTracker = 0;
        %%%% Begin one pass of the grid
        % For every point in z
        for k = randperm(length(1:zDim-zDim*zSym/2))
            % For every points in r
            for j = randperm(length(1:rDim))
                % If the point is not in the plateau region
                if sum((points(:,1)==j).*points(:,2)==k) < 1
                    % If there is a neighboring point that is non-zero in
                    % the shift matrix
                    if buildNextToPW(j,k,cSM{i})
                        % If the addition of the adjustment scalar doesn't
                        % bring it above the plateau height
                        if abs(cSM{i}(j,k) + adjustmentScalar) < goalHeight
                            % Create temporary shift matrix
                            tSM = cSM{i};
                            % Add adjustment scalar
                            rVar = randomAd*rand()/2+0.5;
                            tSM(j,k) = tSM(j,k) + adjustmentScalar*(rVar);
                            if zSym
                                tSM(j,zDim-k+1) = tSM(j,zDim-k+1) + adjustmentScalar*(rVar);
                            end
                            
                            % Update State
                            tM = makeMetricPW(tSM, padding);
                            gpuDevice(1);
                            tED = calcEnDenPW(tM,useGPU);
                            tF = calcFitPW(tSM, tED, innerR, goalHeight);
                            
                            % Calculate realtive fitness
                            metricRelFitness = tF-cF(i);
                            
                            % If better than current metric
                            if metricRelFitness > 0
                                % Set state
                                cSM{i} = tSM;
                                cM{i} = tM;
                                cED{i} = tED;
                                cF(i) = tF;
                                % Print changed point
                                fprintf(repmat('\b',1,failTracker))
                                failTracker = 0;
                                fprintf('Built Point At: %4i, %4i \n',j,k);
                                % Display graph
                                drawWarpFieldPW(cSM{end})
                            else
                                fprintf('.')
                                failTracker = failTracker + 1;
                            end
                        end
                    end
                end
            end
        end
        
        fprintf(repmat('\b',1,failTracker))
        fprintf('Iter: %2i-%2i, Fit: %.8f, AdScalar: %.4f\n',rounds,i,cF(i),adjustmentScalar);
        % If no point is changed in a pass continue to the next round
        if cSM{i}==cSM{i-1}
            break
        end
        i = i + 1;
    end
end

drawWarpFieldPW(cSM{end})



