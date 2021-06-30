function mom_streamline_plot_sqrgrid_animated(Metric,WorldSize,spatialRes,runname,Zcuts,gridres,Xlims,Ylims,scale)
%FUN_VISDATA Summary of this function goes here
%   Detailed explanation goes here
EarthMass = 5.972*10^(24); %kg
c = 2.998*10^6; %m/s
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

% posEnergy = Energy;
% posEnergy(posEnergy<0) = 0;
% negEnergy = Energy;
% negEnergy(negEnergy>0) = 0;


MagMom = (MomX.^2+MomY.^2+MomZ.^2).^0.5;
MomX = MomX./MagMom*scale;
MomY = MomY./MagMom*scale;
MomZ = MomZ./MagMom*scale;

MomX(isnan(MomX)) = 0;
MomY(isnan(MomY)) = 0;
MomZ(isnan(MomZ)) = 0;

X = linspace(0,WorldSize(1),size(Energy,1));
Y = linspace(0,WorldSize(2),size(Energy,2));
Z = linspace(0,WorldSize(3),size(Energy,3));

Xpoints = Zcuts;
Zpoints = linspace(Xlims(1),Xlims(2),gridres);
Ypoints = linspace(Ylims(1),Ylims(2),gridres);


figure()
hold on
% h = slice(X,Y,Z,Energy,max(X)/2,[],[]);
% set(h,'EdgeColor','none','FaceColor','interp')
% h = slice(X,Y,Z,Energy,[],max(Y)/2,[]);
% set(h,'EdgeColor','none','FaceColor','interp')
% h = slice(X,Y,Z,Energy,[],[],max(Z)/2);
% set(h,'EdgeColor','none','FaceColor','interp')


[x,y,z] = meshgrid(X,Y,Z);
[Xstart,Ystart,Zstart] = meshgrid(Xpoints,Ypoints,Zpoints);

verts = stream3(x,y,z,MomX,MomY,MomZ,Xstart,Ystart,Zstart); 

sl = streamline(verts);

view(3)
axis tight;
set(gca,'BoxStyle','full','Box','on')

% set(gca,'SortMethod','childorder');
streamparticles(verts,1,...
	'Animate',Inf,'FrameRate',60,...
	'ParticleAlignment','on',...
	'MarkerEdgeColor','none',...
	'MarkerFaceColor','red',...
	'Marker','o');

set(gcf,'color','w');
sgtitle(f,['Result Case: ' runname])
end

