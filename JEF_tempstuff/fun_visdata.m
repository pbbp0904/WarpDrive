function fun_visdata(Metric,WorldSize,spatialRes,runname)
%FUN_VISDATA Summary of this function goes here
%   Detailed explanation goes here
EarthMass = 5.972*10^(24); %kg
c = 2.998*10^6; %m/s
StressEnergyTensor = met2den(Metric);
Energy = StressEnergyTensor{1,1};
Energy = squeeze(Energy)*spatialRes^2;

MomX = StressEnergyTensor{1,2};
MomX = squeeze(MomX);
% MomX = MomX.*sign(Energy);

MomY = StressEnergyTensor{1,3};
MomY = squeeze(MomY);
% MomY = MomY.*sign(Energy);

MomZ = StressEnergyTensor{1,4};
MomZ = squeeze(MomZ);
% MomZ = MomZ.*sign(Energy);

posEnergy = Energy;
posEnergy(posEnergy<0) = 0;
negEnergy = Energy;
negEnergy(negEnergy>0) = 0;

X = linspace(0,WorldSize(1),size(Energy,1));
Y = linspace(0,WorldSize(2),size(Energy,2));
Z = linspace(0,WorldSize(3),size(Energy,3));
% 
% figure()
% hold on
% lvls = linspace(min(Energy,[],'all'),max(Energy,[],'all'),30);
% contourslice(X,Y,Z,Energy,max(X)/2,[],[],lvls)
% contourslice(X,Y,Z,Energy,[],max(Y)/2,[],lvls)
% contourslice(X,Y,Z,Energy,[],[],max(Z)/2,lvls)
% colorbar
% view(3)
% grid on


f = figure();
az = 90+45;
el = 30;
xlimits = [WorldSize(1)/2 WorldSize(1)*0.9];
ylimits = [WorldSize(2)/2 WorldSize(2)*0.9];
zlimits = [WorldSize(3)/2 WorldSize(3)*0.9];

%% Plotting energy contours
subplot(1,2,1);
hold on
h = slice(X,Y,Z,Energy,max(X)/2,[],[]);
set(h,'EdgeColor','none','FaceColor','interp')
h = slice(X,Y,Z,Energy,[],max(Y)/2,[]);
set(h,'EdgeColor','none','FaceColor','interp')
h = slice(X,Y,Z,Energy,[],[],max(Z)/2);
set(h,'EdgeColor','none','FaceColor','interp')


% lvls = linspace(max(abs(posEnergy)*0.1,[],'all'),max(abs(posEnergy),[],'all'),CountourRes);
% contourslice(X,Y,Z,abs(posEnergy),max(X)/2,[],[],lvls)
% % contourslice(X,Y,Z,abs(posEnergy),[],max(Y)/2,[],lvls)
% contourslice(X,Y,Z,abs(posEnergy),[],[],max(Z)/2,lvls)

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2),0,0)
% text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2)/2,0,0,'k')
% text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,ylimits(2)/2,0,'k')
% text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,zlimits(2)/2,'k')
% text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')

cbar = colorbar('southoutside');
cbar.Label.String = 'Energy Density [J/m^3]';
colormap(jet)
view(az,el)
xlabel('X [m]')
ylabel('Y [m]')
zlabel('Z [m]')
title('T_{00} Energy Density')


fig = subplot(1,2,2);
beta = squeeze(Metric{1,4});
surf(X,Y,abs(beta(:,:,round(end/2))),'FaceColor','interp','FaceLighting','gouraud','EdgeColor','none')
camlight('headlight')
xlabel('X [m]')
ylabel('Y [m]')
zlabel('|\beta|')
a = annotation('textbox','String',{['E_{pos}: ' num2str(sum(posEnergy,'all'),2) ' J'],['M_{pos}: ' num2str(round(sum(posEnergy,'all')/c^2/EarthMass),2) ' M_E'],['E_{neg}: ' num2str(round(sum(negEnergy,'all')),2) ' J'],['M_{neg}: ' num2str(round(sum(negEnergy,'all')/c^2/EarthMass),2) ' M_E']},'Position',fig.Position,'Vert','top','HorizontalAlignment','left','FitBoxToText','on');
a.EdgeColor = 'w';
cbar = colorbar('southoutside');
cbar.Label.String = ['\beta'];
title('dx/dt Metric Element')
view(az,el)

% setting background to white and make global title
set(gcf,'color','w');
sgtitle(f,['Result Case: ' runname])

% fig = subplot(2,2,2);
% hold on
% h = slice(X,Y,Z,abs(negEnergy),max(X)/2,[],[]);
% set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
% alpha('color')
% % h = slice(X,Y,Z,abs(negEnergy),[],max(Y)/2,[]);
% % set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
% % alpha('color')
% h = slice(X,Y,Z,abs(negEnergy),[],[],max(Z)/2);
% set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
% alpha('color')
% 
% lvls = linspace(max(abs(negEnergy)*0.1,[],'all'),max(abs(negEnergy),[],'all'),CountourRes);
% contourslice(X,Y,Z,abs(negEnergy),max(X)/2,[],[],lvls)
% % contourslice(X,Y,Z,abs(negEnergy),[],max(Y)/2,[],lvls)
% contourslice(X,Y,Z,abs(negEnergy),[],[],max(Z)/2,lvls)
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2),0,0)
% text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2)/2,0,0,'k')
% text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,ylimits(2)/2,0,'k')
% text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,zlimits(2)/2,'k')
% text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')
% 
% cbar = colorbar;
% cbar.Label.String = 'Energy Density (absolute) [J/m^3]';
% 
% view(3)
% grid on
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% xlim(xlimits)
% ylim(ylimits)
% zlim(zlimits)
% 
% title('Energy Density (-)')
% a = annotation('textbox','String',{['E_{neg}: ' num2str(sum(negEnergy,'all')) ' J'],['M_{neg}: ' num2str(sum(negEnergy,'all')/c^2/EarthMass) ' M_E']},'Position',fig.Position,'Vert','top','HorizontalAlignment','left','FitBoxToText','on');
% a.EdgeColor = 'w';

%% Plotting energy isosurfaces
% fig3 = subplot(2,2,3);
% hold on
% lvls = -linspace(max(abs(negEnergy)*0.1,[],'all'),max(abs(negEnergy),[],'all'),CountourRes);
% 
% for i = 1:length(lvls)
% p = patch(isosurface(X,Y,Z,negEnergy,lvls(i)));
% isonormals(X,Y,Z,negEnergy,p)
% map(i,:) = [i/length(lvls),(1-i/length(lvls)),0];
% set(p,'FaceColor',map(i,:),'EdgeColor','none','FaceAlpha',i/length(lvls)/5)
% end
% 
% lvls = linspace(max(abs(posEnergy)*0.1,[],'all'),max(abs(posEnergy),[],'all'),CountourRes);
% for i = 1:length(lvls)
% p = patch(isosurface(X,Y,Z,posEnergy,lvls(i)));
% isonormals(X,Y,Z,posEnergy,p)
% map(length(lvls)+i,:) = [0,(1-i/length(lvls)),i/length(lvls)];
% set(p,'FaceColor',map(length(lvls)+i,:),'EdgeColor','none','FaceAlpha',i/length(lvls)/5)
% end
% 
% 
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2),0,0)
% text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2)/2,0,0,'k')
% text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,ylimits(2)/2,0,'k')
% text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')
% 
% quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,zlimits(2)/2,'k')
% text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')
% 
% xlim(xlimits)
% ylim(ylimits)
% zlim(zlimits)
% colorbar
% colormap(fig3,map)
% 
% % caxis(fig3, [min(negEnergy,[],'all') max(posEnergy,[],'all')])
% 
% view(3)

% subplot(2,2,4)
% hold on
% %build quiver vectors
% n=1;
% Xs = zeros(1,length(X)*length(Y)*length(Z));
% Ys = zeros(1,length(X)*length(Y)*length(Z));
% Zs = zeros(1,length(X)*length(Y)*length(Z));
% U = zeros(1,length(X)*length(Y)*length(Z));
% V = zeros(1,length(X)*length(Y)*length(Z));
% W = zeros(1,length(X)*length(Y)*length(Z));
% 
% for i = 1:length(X)
%     for j = 1:length(Y)
%         for k = 1:length(Z)
%             Xs(n) = X(i);
%             Ys(n) = Y(j);
%             Zs(n) = Z(k);
%             
%             U(n) = MomX(i,j,k);
%             V(n) = MomY(i,j,k);
%             W(n) = MomZ(i,j,k);
%                        
%             n = n+1;
%         end
%     end
% end
% 
% %define a start grid for the streamline
% Xpoints = linspace(min(X),max(X),10);
% % Ypoints = linspace(min(Y),max(Y),20);
% Ypoints = [2,4,6,8];
% Zpoints = linspace(min(Z),max(Z),10);
% n = 1;
% for i = 1:length(Xpoints)
%     for j = 1:length(Ypoints)
%         for k = 1:length(Zpoints)
%             Xstart(n) = Xpoints(i);
%             Ystart(n) = Ypoints(j);
%             Zstart(n) = Zpoints(k); 
%             n=n+1;
%         end
%     end
% end
% 
% quiver3(Xs,Ys,Zs,U,V,W,'k')
% scatter3(Xstart,Ystart,Zstart,'.r')
% streamline(stream3(X,Y,Z,MomX,MomY,MomZ,Xstart,Ystart,Zstart))
% 
% % xlim(xlimits)
% % ylim(ylimits)
% % zlim(zlimits)
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% view(3)

end

