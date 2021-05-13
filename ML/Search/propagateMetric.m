%%%% Starting Params
% Z Dimension Size
zDim = 30;
% R Dimension Size
rDim = 15;
% XYZ Padding
padding = 3;
% Z Symmetry
zSym = 1;
% Randomness
randomAd = 0;
% Max Training for One Adjustment Scalar
maxTrain = 1000000000;
% Plateau Radius
innerR = 3;
% Plateau Height
goalHeight = 9;


%%%% Setup
% Makes the initial shift matrix with the plateau
% also computes the points inside the radius that the interation should ignore

[shiftMatrixStart, points] = makeAlcubierreShiftMatrixPW(rDim,zDim,innerR,goalHeight,2);

