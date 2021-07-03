spatialResolution = 1;
WorldSize = 134;
spatialExtent = [WorldSize,WorldSize,WorldSize];
R_input = 2;
R = R_input/spatialResolution;
gridSize = spatialExtent./spatialResolution;

sig = 1.5;
vs = 3;

%% Run numerical code
energies = [];
energiesPos = [];

% shiftMatricies = makeAlcubierreShiftMatrixPW(round(gridSize(1)/2),gridSize(3),R,vs,sig);
% AM2 = makeMetricPW(shiftMatricies, 3);
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
scale = 4;

% mom_streamline_plot_sqrgrid_animated(AM2,spatialExtent,1,'test',Zcuts,gridres,Xlims,Ylims,1)

%StressEnergyTensor = met2den(Metric);
Energy = StressEnergyTensor{1,1};
Energy = squeeze(Energy)*spatialRes^2;

MomX = StressEnergyTensor{1,2};
MomX = permute(squeeze(MomX),[2,1,3]);
%MomX = MomX.*sign(Energy);

MomY = StressEnergyTensor{1,3};
MomY = permute(squeeze(MomY),[2,1,3]);
%MomY = MomY.*sign(Energy);

MomZ = StressEnergyTensor{1,4};
MomZ = permute(squeeze(MomZ),[2,1,3]);
%MomZ = MomZ.*sign(Energy);


MagMom = (MomX.^2+MomY.^2+MomZ.^2).^0.5;
MomX = MomX./MagMom*scale;
MomY = MomY./MagMom*scale;
MomZ = MomZ./MagMom*scale;

MomX(isnan(MomX)) = 0;
MomY(isnan(MomY)) = 0;
MomZ(isnan(MomZ)) = 0;

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

rSize = 25;
pSize = 4;
Rpoints = linspace(0,WorldSize/2,rSize);
Ppoints = linspace(0,4*pi*(1-1/pSize),pSize);
[r, th] = meshgrid(Rpoints,Ppoints);
Xstart = r.*cos(th)+WorldSize/2;
Ystart = r.*sin(th)+WorldSize/2;
%Zstart = cat(1,32.*ones(pSize/2, rSize),38.*ones(pSize/2, rSize));
Zstart = cat(1,16.*ones(pSize/2, rSize),54.*ones(pSize/2, rSize));
% Zstart = 35.*ones(pSize, rSize);

verts = stream3(x,y,z,MomX,MomY,MomZ,Xstart,Ystart,Zstart); 

sl = streamline(verts);
xx=get(sl,'XData');
yy=get(sl,'YData');
zz=get(sl,'ZData');
set(gcf,'color','w');
%% Test Code
filename = 'testAnimated.gif';


rotationAmount = 0; % Total degrees of rotation in the gif
numberOfFrames = 24*10; % Total number of frames
frameDuration = 1/24; % Length of a single frame in seconds
logValue = 0.7;

f = figure(5)
% styleName = 'WarpDriveStyle';
% s=hgexport('readstyle',styleName);

filename = 'testAnimated.gif';

% numberOfFrame = round(max(cellfun('size',xx,2))/10);
for j = 1:round(max(cellfun('size',xx,2))/3)
clf
hold on
for i = 1:size(xx,1)    
        plot3(xx{i,1},yy{i,1},zz{i,1},'Color',[0,0,1,0.1],'LineWidth',1)
end
for i = 1:size(xx,1)    
    if size(xx{i,1},2) > j 
        plot3(xx{i,1}(1:j),yy{i,1}(1:j),zz{i,1}(1:j),'b','LineWidth',1.5)        
    end
end

% for i = 1:size(xx,1)    
%     if size(xx{i,1},2) > j && mod(j,10) == 0
%         scatter3(xx{i,1}(j),yy{i,1}(j),zz{i,1}(j),'Filled','MarkerFaceColor','r')        
%     end
% end


    set(gca,'DataAspectRatio',[1 1 1]);
    %view(30+j*rotationAmount/numberOfFrames,20);
    view(0,0)

     xlim([0,WorldSize])
     ylim([0,WorldSize])
     zlim([10,60])
%     xlim([93,120])
%     ylim([0,WorldSize])

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


