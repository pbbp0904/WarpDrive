
spatialResolution = 0.2;
WorldSize = 10;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = 1.5;
vs = 3;

%% Run numerical code
% energies = [];
% energiesPos = [];
% 
% shiftMatricies = makeAlcubierreShiftMatrixPW(round(gridSize(1)/2),gridSize(3),R,vs,sig);
% AM2 = makeMetricPW(shiftMatricies, 3);
% % AM = metricGPUGet_Alcubierre(0,vs,R,sig,gridSize);

% Z = met2den(AM);
load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-4z-30r-2v.mat')
AM2 = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(AM2);
%% Test visfunction
% fun_visdata(AM2,spatialExtent,1,'Alcubierre Metric')
%  mom_streamline_plot_sqrgrid(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])
%  mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])
WorldSize = [134,134,70];

c = 2.99792*10^8;
% mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'test',Zcuts,gridres,Xlims,Ylims,1)

Metric = AM2;
scale = 1;

% mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'test',Zcuts,gridres,Xlims,Ylims,1)

%StressEnergyTensor = met2den(Metric);
Energy = StressEnergyTensor{1,1};
Energy = squeeze(Energy)*spatialRes^2;

MomX = -StressEnergyTensor{1,2}./StressEnergyTensor{1,1};
MomX = permute(squeeze(MomX),[2,1,3]);
MomX = c*MomX./(sqrt(c^2+MomX.^2));
%MomX = MomX.*sign(Energy);

MomY = -StressEnergyTensor{1,3}./StressEnergyTensor{1,1};
MomY = permute(squeeze(MomY),[2,1,3]);
MomY = c*MomY./(sqrt(c^2+MomY.^2));
%MomY = MomY.*sign(Energy);

MomZ = -StressEnergyTensor{1,4}./StressEnergyTensor{1,1};
MomZ = permute(squeeze(MomZ),[2,1,3]);
MomZ = c*MomZ./(sqrt(c^2+MomZ.^2));
%MomZ = MomZ.*sign(Energy);


%MagMom = (MomX.^2+MomY.^2+MomZ.^2).^0.5;
MagMom = 1;
MomX = MomX./MagMom*scale;
MomY = MomY./MagMom*scale;
MomZ = MomZ./MagMom*scale;

MomX(isnan(MomX)) = 0;
MomY(isnan(MomY)) = 0;
MomZ(isnan(MomZ)) = 0;
MomX(isinf(MomX)) = 0;
MomY(isinf(MomY)) = 0;
MomZ(isinf(MomZ)) = 0;

X = linspace(0,WorldSize(1),size(Energy,1));
Y = linspace(0,WorldSize(2),size(Energy,2));
Z = linspace(0,WorldSize(3),size(Energy,3));



hold on
[xx,yy,zz] = meshgrid(X,Y,Z);

%% Plotting Code
load('Outputs\WarpDriveStyle.mat')
filename = 'testAnimated.gif';
plotname = 'AM Test Metric';

rotationAmount = 180; % Total degrees of rotation in the gif
% numberOfFrames = 24*10; % Total number of frames
frameDuration = 1/24; % Length of a single frame in seconds
logValue = 0.7;

f = figure()

    clf
subplot(1,3,1)
    hold on
    quiver(X(1:2:end),Y(1:2:end),squeeze(MomX(1:2:end,1:2:end,round(end/2))'),squeeze(MomY(1:2:end,1:2:end,round(end/2)))')
     imagesc(X,Y,abs(squeeze(Energy(:,:,round(end/2)))));
    alpha color
    alpha scaled
    %label
    xlabel('X')
    ylabel('Y')
    title(plotname)

subplot(1,3,2)
    hold on
    quiver(X(1:2:end),Z(1:1:end),squeeze(MomX(1:2:end,round(end/2),1:1:end))',squeeze(MomZ(1:2:end,round(end/2),1:1:end))')
    imagesc(X,Z,abs(squeeze(Energy(:,round(end/2),:)))');
    alpha color
    alpha scaled
    %label
    xlabel('X')
    ylabel('Z')
    title(plotname)

    
subplot(1,3,3)
    hold on
    quiver(Y(1:2:end),Z(1:1:end),squeeze(MomY(round(end/2),1:2:end,1:1:end))',squeeze(MomZ(round(end/2),1:2:end,1:1:end))')
    imagesc(Y,Z,abs(squeeze(Energy(round(end/2),:,:)))');
    alpha color
    alpha scaled
    %label
    xlabel('Y')
    ylabel('Z')
    title(plotname)

    %apply settings
    s.Format = 'png';
    hgexport(f,'temp_dummy',s,'applystyle', true)
    frame = getframe(f); 
colorbar


figure()
quiver3(xx(1:2:end,1:2:end,1:2:end),yy(1:2:end,1:2:end,1:2:end),zz(1:2:end,1:2:end,1:2:end),MomX(1:2:end,1:2:end,1:2:end),MomY(1:2:end,1:2:end,1:2:end),MomZ(1:2:end,1:2:end,1:2:end))
% xlim([min(X) max(X)/2])
% ylim([min(Y) max(Y)/2])
zlim([max(Z)/3 2*max(Z)/3])
%% functions
function maxval = findmax_linecell(celldata)
   maxval_temp = zeros(1,size(celldata,1));
for i = 1:size(celldata,1)
    maxval_temp(i) = max(celldata{i,:});
    end
    maxval = max(maxval_temp);
end

function minval = findmin_linecell(celldata) 
minval_temp = zeros(1,size(celldata,1));
for i = 1:size(celldata,1)
        minval_temp(i) = min(celldata{i,:});
    end
    minval = min(minval_temp);
end

