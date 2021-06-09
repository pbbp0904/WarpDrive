spatialResolution = 0.1;
WorldSize = 10;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = 1;
vs = 3;

%% Run numerical code
energies = [];
energiesPos = [];

AM = metricGPUGet_Alcubierre(0,vs,R,sig,gridSize);
Z = met2den(AM);

%% Test visfunction
fun_visdata(AM,Z,spatialExtent,20,'Alcubierre Metric')

