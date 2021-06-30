spatialResolution = 0.2;
WorldSize = 10;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = 1.5;
vs = 3;

%% Run numerical code
energies = [];
energiesPos = [];

shiftMatricies = makeAlcubierreShiftMatrixPW(round(gridSize(1)/2),gridSize(3),R,vs,sig);
AM2 = makeMetricPW(shiftMatricies, 3);
% AM = metricGPUGet_Alcubierre(0,vs,R,sig,gridSize);

% Z = met2den(AM);

%% Test visfunction
fun_visdata(AM2,spatialExtent,1,'Alcubierre Metric')
%  mom_streamline_plot_sqrgrid(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])
%  mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])

spatialRes=1;
Xlims = [3 7];
Ylims = [3 7];
Zcuts = 5;
gridres = 6;

mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'test',Zcuts,gridres,Xlims,Ylims,1)



