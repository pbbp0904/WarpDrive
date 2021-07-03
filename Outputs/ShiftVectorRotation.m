%load('C:\Users\chris\Documents\MATLAB\WarpDrive\ML\AdaptiveSearch\UFO\z30_r60_b10_UFO.mat')

A = RunData.shiftMatricies{end};
B = cat(1,flipud(A),A);

h = figure;
load('WarpDriveStyle');

% styleName = 'WarpDrive1';
% s=hgexport('readstyle',styleName);

filename = 'testAnimated.gif';

iMod = 20; % Draw every iMod changes
gifLength = 10; % seconds
rotationAmount = 0; % Total degrees of rotation in the gif

for i = 1:iMod:length(RunData.shiftMatricies)
    
    A = RunData.shiftMatricies{i};
    B = cat(1,flipud(A),A);
    
    % Radial Trim
    %B = B(10:110,:);
    
    % Redraw plot
    surf(B,'FaceColor','interp','EdgeColor','interp','FaceLighting','gouraud');
    
    % Set limits
    xlim([1 64])
    ylim([1 128])
    zlim([1.02*min(B,[],'all'), 1.02*max(B,[],'all')])
    
    % Set labels
    xlabel('Z')
    ylabel('\rho')
    zlabel('\beta')
    %title(sprintf("Net Energy: %1.2e",RunData.totalPosEnergies{i}-RunData.totalNegEnergies{i}))
    title(sprintf("Total Energy: %1.2e",abs(RunData.totalPosEnergies{i})+abs(RunData.totalNegEnergies{i})))
    colormap(turbo);
    
    % Change view
    set(gca,'DataAspectRatio',[10 10 1]);
    view(30+i*rotationAmount/length(RunData.shiftMatricies),20);
    
    % Set style
    s.Format = 'png';
    hgexport(h,'temp_dummy',s,'applystyle', true);
    
    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    
    % Write to the GIF file 
    if i == 1 
        imwrite(imind,cm,filename,'gif', 'Loopcount',inf,'DelayTime',2); 
    else 
        imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',iMod*gifLength/length(RunData.shiftMatricies)); 
    end 
end

imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',2);
