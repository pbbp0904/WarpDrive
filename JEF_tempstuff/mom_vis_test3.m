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

rSize = 10;
pSize = 4;

Rpoints = linspace(0,WorldSize/3,rSize);
Ppoints = linspace(0,4*pi*(1-1/pSize),pSize);
[r, th] = meshgrid(Rpoints,Ppoints);
Xstart = r.*cos(th)+WorldSize/2;
Ystart = r.*sin(th)+WorldSize/2;
Zstart = cat(1,(70/2).*ones(pSize/2, rSize),(70/2).*ones(pSize/2, rSize));
%Zstart = cat(1,16.*ones(pSize/2, rSize),54.*ones(pSize/2, rSize));
%Zstart = 67.*ones(pSize, rSize);

verts = stream3(x,y,z,MomX,MomY,MomZ,Xstart,Ystart,Zstart); 

sl = streamline(verts);
xx=get(sl,'XData');
yy=get(sl,'YData');
zz=get(sl,'ZData');

%% Test Code
load('Outputs\WarpDriveStyle.mat')

rotationAmount = 0; % Total degrees of rotation in the gif
numberOfFrames = 30*15; % Total number of frames
frameDuration = 1/3; % Length of a single frame in seconds

h = figure();
clf
%load('WarpDriveStyle.mat')

filename = 'testAnimated.gif';

% numberOfFrame = round(max(cellfun('size',xx,2))/10);
%for j = 1:round(max(cellfun('size',xx,2))/3)
    hold on
        splot = slice(X, Y, Z, abs(Energy),[] , 134/2, []);
    set(splot,'EdgeColor','none','FaceColor','interp');   
    
    for i = 1:size(xx,1)    
            plot3(xx{i,1},yy{i,1},zz{i,1},'Color',[0,0,0,1],'LineWidth',1)
    end
    
    for i = 1:size(xx,1)    
            scatter3(xx{i,1}(1),yy{i,1}(1),zz{i,1}(1),8,'r','Filled')
    end

     

    

    
    alpha color
    % Set limits
    xlim([1,134])
    ylim([1,134])
    zlim([70/2-40,70/2+40])
    
    % Set labels
    xlabel('Y')
    ylabel('X')
    zlabel('Z')
    %title(sprintf("Net Energy: %1.2e",RunData.totalPosEnergies{i}-RunData.totalNegEnergies{i}))
    title('Alcubierre Energy Flow')
    
    % Change view
%     set(gca,'DataAspectRatio',[1 1 1]);
    view(0,0)

%     view(30,20)

    % Set style
    s.Format = 'png';
    hgexport(h,'temp_dummy',s,'applystyle', true);
            drawnow
%     % Capture the plot as image
%     frame = getframe(h); 
%     im = frame2im(frame); 
%     [imind,cm] = rgb2ind(im,256); 
%     
% 	% Write to the GIF file 
%     if j == 1 
%         imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',frameDuration); 
%     else 
%         imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration); 
%     end
%     if j == 166
%         pause
%     end

% 
% imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration);


