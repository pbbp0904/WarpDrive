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
% fun_visdata(AM2,spatialExtent,1,'Alcubierre Metric')
%  mom_streamline_plot_sqrgrid(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])
%  mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'Alcubierre Metric',[2 5],5,[2 8],[2 8])

spatialRes=1;
Xlims = [3 7];
Ylims = [3 7];
Zcuts = 5;
gridres = 6;
Metric = AM2;
scale = 1;
Xpoints = linspace(0,WorldSize/2,5);
Ypoints = linspace(0,WorldSize/2,5);
Zpoints = 5
% mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'test',Zcuts,gridres,Xlims,Ylims,1)

StressEnergyTensor = met2den(Metric);
Energy = StressEnergyTensor{1,1};
Energy = squeeze(Energy)*spatialRes^2;

MomX = StressEnergyTensor{1,2};
MomX = -squeeze(MomX);
MomX = MomX.*sign(Energy);

MomY = StressEnergyTensor{1,3};
MomY = squeeze(MomY);
MomY = MomY.*sign(Energy);

MomZ = StressEnergyTensor{1,4};
MomZ = squeeze(MomZ);
MomZ = MomZ.*sign(Energy);


MagMom = (MomX.^2+MomY.^2+MomZ.^2).^0.5;
MomX = MomX./MagMom*scale;
MomY = MomY./MagMom*scale;
MomZ = MomZ./MagMom*scale;

MomX(isnan(MomX)) = 0;
MomY(isnan(MomY)) = 0;
MomZ(isnan(MomZ)) = 0;

X = linspace(0,WorldSize,size(Energy,1));
Y = linspace(0,WorldSize,size(Energy,2));
Z = linspace(0,WorldSize,size(Energy,3));



hold on
[x,y,z] = meshgrid(X,Y,Z);
[Xstart,Ystart,Zstart] = meshgrid(Xpoints,Ypoints,Zpoints);

verts = stream3(x,y,z,MomX,MomY,MomZ,Xstart,Ystart,Zstart); 

sl = streamline(verts);
xx=get(sl,'XData');
yy=get(sl,'YData');
zz=get(sl,'ZData');
set(gcf,'color','w');
%% Test Code
filename = 'testAnimated.gif';


rotationAmount = 90; % Total degrees of rotation in the gif
numberOfFrames = 24*10; % Total number of frames
frameDuration = 1/24; % Length of a single frame in seconds
logValue = 0.7;

f = figure(5)
% styleName = 'WarpDriveStyle';
% s=hgexport('readstyle',styleName);

filename = 'testAnimated.gif';

% numberOfFrame = round(max(cellfun('size',xx,2))/10);
for j = 1:round(max(cellfun('size',xx,2))/10)
clf
hold on
for i = 1:size(xx,1)    
        plot3(xx{i,1},yy{i,1},zz{i,1},'Color',[0,0,1,0.1],'LineWidth',1)
end
for i = 1:size(xx,1)    
    if size(xx{i,1},2) > j 
        plot3(xx{i,1}(1:j),yy{i,1}(1:j),zz{i,1}(1:j),'b','LineWidth',2)        
    end
end

% for i = 1:size(xx,1)    
%     if size(xx{i,1},2) > j && mod(j,10) == 0
%         scatter3(xx{i,1}(j),yy{i,1}(j),zz{i,1}(j),'Filled','MarkerFaceColor','r')        
%     end
% end


    set(gca,'DataAspectRatio',[1 1 1]);
    view(j*rotationAmount/numberOfFrames,20);

     


    % Set style
%     s.Format = 'png';
%     hgexport(h,'temp_dummy',s,'applystyle', true);
    frame = getframe(f); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    
%     Write to the GIF file 
    if j == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',frameDuration); 
    else 
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration); 
    end 
end
% 
% imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration);


