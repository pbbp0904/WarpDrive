function fun_visdata(StressEnergyTensor,WorldSize,runname)
%FUN_VISDATA Summary of this function goes here
%   Detailed explanation goes here

Energy = StressEnergyTensor{1,1};
Energy = squeeze(Energy);

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
xlimits = [WorldSize(1)*0.1 WorldSize(1)*0.9];
ylimits = [WorldSize(2)*0.1 WorldSize(2)*0.9];
zlimits = [WorldSize(3)*0.1 WorldSize(3)*0.9];

fig = subplot(2,2,1);
hold on
h = slice(X,Y,Z,abs(posEnergy),max(X)/2,[],[]);
set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
alpha('color')
% h = slice(X,Y,Z,abs(posEnergy),[],max(Y)/2,[]);
% set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
% alpha('color')
h = slice(X,Y,Z,abs(posEnergy),[],[],max(Z)/2);
set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
alpha('color')

lvls = linspace(max(abs(posEnergy)*0.1,[],'all'),max(abs(posEnergy),[],'all'),10);
contourslice(X,Y,Z,abs(posEnergy),max(X)/2,[],[],lvls)
% contourslice(X,Y,Z,abs(posEnergy),[],max(Y)/2,[],lvls)
contourslice(X,Y,Z,abs(posEnergy),[],[],max(Z)/2,lvls)

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2),0,0)
text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2)/2,0,0,'k')
text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,ylimits(2)/2,0,'k')
text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,zlimits(2)/2,'k')
text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')

cbar = colorbar;
cbar.Label.String = 'Energy Density (absolute) [J/m^3]';

view(3)
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
title('Energy Density (+)')
xlim(xlimits)
ylim(ylimits)
zlim(zlimits)

annotation('textbox','String',['E_{pos}: ' num2str(sum(posEnergy,'all')) ' [J]'],'Position',fig.Position,'Vert','top','HorizontalAlignment','left','FitBoxToText','on')

fig = subplot(2,2,2);
hold on
h = slice(X,Y,Z,abs(negEnergy),max(X)/2,[],[]);
set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
alpha('color')
% h = slice(X,Y,Z,abs(negEnergy),[],max(Y)/2,[]);
% set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
% alpha('color')
h = slice(X,Y,Z,abs(negEnergy),[],[],max(Z)/2);
set(h,'EdgeColor','none','FaceColor','interp','FaceAlpha','interp')
alpha('color')

lvls = linspace(max(abs(negEnergy)*0.1,[],'all'),max(abs(negEnergy),[],'all'),10);
contourslice(X,Y,Z,abs(negEnergy),max(X)/2,[],[],lvls)
% contourslice(X,Y,Z,abs(negEnergy),[],max(Y)/2,[],lvls)
contourslice(X,Y,Z,abs(negEnergy),[],[],max(Z)/2,lvls)

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2),0,0)
text(max(X),max(Y)/2,max(Z)/2,'(v_s dir)')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,xlimits(2)/2,0,0,'k')
text(max(X)/2+xlimits(2)/2,max(Y)/2,max(Z)/2,'x')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,ylimits(2)/2,0,'k')
text(max(X)/2,max(Y)/2+ylimits(2)/2,max(Z)/2,'y')

quiver3(max(X)/2,max(Y)/2,max(Z)/2,0,0,zlimits(2)/2,'k')
text(max(X)/2,max(Y)/2,max(Z)/2+zlimits(2)/2,'z')

cbar = colorbar;
cbar.Label.String = 'Energy Density (absolute) [J/m^3]';

view(3)
grid on
xlabel('X')
ylabel('Y')
zlabel('Z')
xlim(xlimits)
ylim(ylimits)
zlim(zlimits)

title('Energy Density (-)')
annotation('textbox','String',['E_{neg}: ' num2str(sum(negEnergy,'all')) ' [J]'],'Position',fig.Position,'Vert','top','HorizontalAlignment','left','FitBoxToText','on')

% box on
set(gcf,'color','w');

sgtitle(f,['Result Case: ' runname])
end

