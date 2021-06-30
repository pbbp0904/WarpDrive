function [energyDensity] = met2den(metricTensor)
%MET2DEN Coverts a catesian metric tensor to the corresponding energy 
%   density tensor using the Einstien Field Equations
%   Takes an input of a 4x4 cell array as the metric tensor and outputs a
%   4x4 cell array as the energy density tensor
%
%   INPUT: 4x4 cell array. Elements of cell array are 4-D matricies of
%   double type
%
%
%   OUPUT: 4x4 cell array. Elements of cell array are 4-D matricies of
%   double type



% Metric tensor and its inverse
gl = metricTensor;
gu = c4Inv(gl);

% Calculate the Christoffel symbols
%tic
%fprintf('Calculating Christoffel Symbols...\n')
%G = christoffelS(gu, gl);
%toc


%fprintf('Calculating Stress-Energy Tensor...\n')

%tic
% Calculate the Ricci tensor
R_munu = ricciT2(gu,gl);

% Calculate the Ricci scalar
R = ricciS(R_munu,gu);

% Calculate Einstien tensor
E = einT(R_munu,R,gl);

% Calculate Energy density
energyDensity = einE(E,gu);
%toc


%fprintf('Done!\n')
end


