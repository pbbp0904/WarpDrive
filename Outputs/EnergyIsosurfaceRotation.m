load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\New Runs\RunData-13-POINT-v2.mat')

% Generate data
tryGPU = 1;
padding = 3;
A = RunData.shiftMatricies{end};
metric = makeMetricPW(A, padding);
energyDensities = calcEnDenPW(metric,tryGPU);
[energyPos, energyNeg] = calcTotalEnergyPW(energyDensities);
totalEnergy = abs(energyPos) + abs(energyNeg);
energyDensity = squeeze(energyDensities{1,1});

h = figure;
styleName = 'WarpDrive1';
s=hgexport('readstyle',styleName);

filename = 'testAnimated.gif';


rotationAmount = 90; % Total degrees of rotation in the gif
numberOfFrames = 24*10; % Total number of frames
frameDuration = 1/24; % Length of a single frame in seconds
logValue = 0.7;

maxAbs = max(abs(energyDensity),[],'all');

isovalues = cat(2,fliplr(-2.^(log2(maxAbs)*logValue:(1-logValue)*log2(maxAbs)/(numberOfFrames/2):log2(maxAbs))),2.^(log2(maxAbs)*logValue:(1-logValue)*log2(maxAbs)/(numberOfFrames/2):log2(maxAbs)));
   
for i = 1:numberOfFrames
    
    
    %isovalue = round(max(energyDensity,[],'all')/2*(1-i/length(RunData.shiftMatricies)) + min(energyDensity,[],'all')/2*(i/length(RunData.shiftMatricies)));
    
    % Redraw plot
    %isosurface(energyDensity,isovalue,'FaceColor','interp','EdgeColor','interp','FaceLighting','gouraud');
    clf
    isosurface(energyDensity,isovalues(i));
    camlight
    lighting gouraud
%     patch('Vertices',verts,'Faces',faces,'FaceVertexCData',[0, 0, 1],'FaceColor','interp','EdgeColor','interp')
    
    % Set limits
    denSize = size(energyDensity);
    xlim([1 denSize(1)])
    ylim([1 denSize(2)])
    zlim([1 denSize(3)])
    
    % Set labels
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
    title(sprintf("Energy Density Value: %1.2e",isovalues(i)))
    %colormap(turbo);
    
    % Change view
    set(gca,'DataAspectRatio',[1 1 1]);
    view(i*rotationAmount/numberOfFrames,20);
    
    % Set style
    s.Format = 'png';
    hgexport(h,'temp_dummy',s,'applystyle', true);
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    
    % Write to the GIF file 
    if i == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',frameDuration); 
    else 
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration); 
    end 
end

imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',frameDuration);
