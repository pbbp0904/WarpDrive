load('C:\Users\j90xb\Desktop\WarpDrive_Project\ML\AdaptiveSearch\New Runs\Cylinders\RunData-6-36z-10r-2v.mat')
AM2 = makeMetricPW(RunData.shiftMatricies{end}, 3);
StressEnergyTensor = met2den(AM2);


spatialResolution = 1;
WorldSize = 134;
spatialExtent = [WorldSize,WorldSize,70];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;
c = 2.99792*10^8;

sig = 1.5;
vs = 3;

%% Run numerical code
energies = [];
energiesPos = [];

% shiftMatricies = makeAlcubierreShiftMatrixPW(round(gridSize(1)/2),gridSize(3),R,vs,sig);
%AM2 = makeMetricPW(RunData.shiftMatricies{end}, 3);
% AM = metricGPUGet_Alcubierre(0,vs,R,sig,gridSize);

% Z = met2den(AM);

%% Test visfunction
% fun_visdata(AM2,spatialExtent,1,'Alcubierre Metric')
%  mom_streamline_plot_sqrgrid(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])
%  mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])

spatialRes=1;
Xlims = [1 3 5 7 9];
Ylims = [1 3 5 7 9];
Zcuts = 5;
gridres = 6;
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

X = linspace(0,WorldSize,size(Energy,1));
Y = linspace(0,WorldSize,size(Energy,2));
Z = linspace(0,70,size(Energy,3));
[x,y,z] = meshgrid(X,Y,Z);


hold on





% Xpoints = linspace(0,WorldSize,25);
% %Ypoints = linspace(0,WorldSize,3);
% Ypoints = linspace(0,WorldSize,25);
% Zpoints = [32 39];
% [Xstart,Ystart,Zstart] = meshgrid(Xpoints,Ypoints,Zpoints);

% rSize = 4;
% pSize = 32;

rSize = 40;
pSize = 4;

Rpoints = linspace(WorldSize/500,WorldSize/3,rSize);
Ppoints = linspace(0,4*pi*(1-1/pSize),pSize);
[r, th] = meshgrid(Rpoints,Ppoints);
Xstart = r.*cos(th)+WorldSize/2;
Ystart = r.*sin(th)+WorldSize/2;
Zstart = cat(1,(70/2-2).*ones(pSize/2, rSize),(70/2+2).*ones(pSize/2, rSize));
%Zstart = cat(1,16.*ones(pSize/2, rSize),54.*ones(pSize/2, rSize));
%Zstart = 67.*ones(pSize, rSize);

verts = stream3(x,y,z,MomX,MomY,MomZ,Xstart,Ystart,Zstart); 

sl = streamline(verts);
xx=get(sl,'XData');
yy=get(sl,'YData');
zz=get(sl,'ZData');

%% Test Code
load('Outputs\WarpDriveStyle.mat')
%% Plotting energy contours
hh = figure();
clf

hold on
h = slice(X,Y,Z,abs(Energy),max(X)/2,[],[]);
set(h,'EdgeColor','none','FaceColor','interp')
h = slice(X,Y,Z,abs(Energy),[],max(Y)/2,[]);
set(h,'EdgeColor','none','FaceColor','interp')
h = slice(X,Y,Z,abs(Energy),[],[],max(Z)/2);
set(h,'EdgeColor','none','FaceColor','interp')


% lvls = linspace(max(abs(posEnergy)*0.1,[],'all'),max(abs(posEnergy),[],'all'),CountourRes);
% contourslice(X,Y,Z,abs(posEnergy),max(X)/2,[],[],lvls)
% % contourslice(X,Y,Z,abs(posEnergy),[],max(Y)/2,[],lvls)
% contourslice(X,Y,Z,abs(posEnergy),[],[],max(Z)/2,lvls)

% quiver3(max(X)/2,max(Y)/2,max(Z)/2,max(X),0,0)
% text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')
% 
quiver3(max(X)/2,max(Y)/2,max(Z)/2,-max(X)/2,0,0,'w')
% text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')
% 
quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,-max(Y),0,'w')
% text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')
% 
quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,max(Z),'w')
% text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')
% alpha color

cbar = colorbar('southoutside');
cbar.Label.String = '|Energy| Density [J/m^3]';
colormap(turbo)
az = 90+45+180;
el = 30;
view(az,el)
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('T^{00} Energy Density - Cylinder (36Z)')
    xlim([30,134/2])
    ylim([30,134/2])
    zlim([70/2,60])

% set(gca, 'ColorScale', 'log')
caxis([0 5*10^40])
% setting background to white and make global title
set(gcf,'color','w');


% 
%     title('Alcubierre Energy Flow')


    % Set style
    s.Format = 'png';
    hgexport(hh,'temp_dummy',s,'applystyle', true);
            drawnow


