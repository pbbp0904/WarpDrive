function [EnergyConditions] = evalEnergyConditions(energyDensity)
%EVALENERGYCONDITIONS returns whether or not the null, weak, dominant, and
%strong energy conditions are violated both point-wsie and on average

% Null
N = squeeze(energyDensity{1,1}) + 1/3*(squeeze(energyDensity{2,2}) + squeeze(energyDensity{3,3}) + squeeze(energyDensity{4,4}));
NSize = numel(N);
NPosSize = numel(N(N>0));
if NSize ~= NPosSize
    EnergyConditions.Null.pointWise = 'Fail';
else
    EnergyConditions.Null.pointWise = 'Pass';
end
EnergyConditions.Null.failRatio = 1-NPosSize/NSize;

NAv = sum(squeeze(energyDensity{1,1}),'all') + 1/3*(sum(squeeze(energyDensity{2,2}),'all') + sum(squeeze(energyDensity{3,3}),'all') + sum(squeeze(energyDensity{4,4}),'all'));
if NAv < 0 
    EnergyConditions.Null.average = 'Fail';
else
    EnergyConditions.Null.average = 'Pass';
end


% Weak
if strcmp(EnergyConditions.Null.pointWise,'Fail') || min(squeeze(energyDensity{1,1}),[],'all') < 0
    EnergyConditions.Weak.pointWise = 'Fail';
else
    EnergyConditions.Weak.pointWise = 'Pass';
end

if strcmp(EnergyConditions.Null.average,'Fail') || sum(squeeze(energyDensity{1,1}),'all') < 0
    EnergyConditions.Weak.average = 'Fail';
else
    EnergyConditions.Weak.average = 'Pass';
end


% Dominant
if strcmp(EnergyConditions.Weak.pointWise,'Fail') || min(squeeze(energyDensity{1,1})-1/3*(sum(squeeze(energyDensity{2,2}),'all') + sum(squeeze(energyDensity{3,3}),'all') + sum(squeeze(energyDensity{4,4}),'all')),[],'all') < 0
    EnergyConditions.Dominant.pointWise = 'Fail';
else
    EnergyConditions.Dominant.pointWise = 'Pass';
end

if strcmp(EnergyConditions.Weak.average,'Fail') || sum(squeeze(energyDensity{1,1})-1/3*(sum(squeeze(energyDensity{2,2}),'all') + sum(squeeze(energyDensity{3,3}),'all') + sum(squeeze(energyDensity{4,4}),'all')),'all') < 0
    EnergyConditions.Dominant.average = 'Fail';
else
    EnergyConditions.Dominant.average = 'Pass';
end


% Strong
if strcmp(EnergyConditions.Null.pointWise,'Fail') || min(squeeze(energyDensity{1,1})-(sum(squeeze(energyDensity{2,2}),'all') + sum(squeeze(energyDensity{3,3}),'all') + sum(squeeze(energyDensity{4,4}),'all')),[],'all') < 0
    EnergyConditions.Strong.pointWise = 'Fail';
else
    EnergyConditions.Strong.pointWise = 'Pass';
end

if strcmp(EnergyConditions.Null.average,'Fail') || sum(squeeze(energyDensity{1,1})-(sum(squeeze(energyDensity{2,2}),'all') + sum(squeeze(energyDensity{3,3}),'all') + sum(squeeze(energyDensity{4,4}),'all')),'all') < 0
    EnergyConditions.Strong.average = 'Fail';
else
    EnergyConditions.Strong.average = 'Pass';
end

end

