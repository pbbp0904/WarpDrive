function mom_streamline_plot_sqrgrid(Metric,WorldSize,spatialRes,runname,Zcuts,gridres,Xlims,Ylims)
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
MomY = -squeeze(MomY);
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


hold on
%build quiver vectors
n=1;
Xs = zeros(1,length(X)*length(Y)*length(Z));
Ys = zeros(1,length(X)*length(Y)*length(Z));
Zs = zeros(1,length(X)*length(Y)*length(Z));
U = zeros(1,length(X)*length(Y)*length(Z));
V = zeros(1,length(X)*length(Y)*length(Z));
W = zeros(1,length(X)*length(Y)*length(Z));

for i = 1:length(X)
    for j = 1:length(Y)
        for k = 1:length(Z)
            Xs(n) = X(i);
            Ys(n) = Y(j);
            Zs(n) = Z(k);
            
            U(n) = MomX(i,j,k);
            V(n) = MomY(i,j,k);
            W(n) = MomZ(i,j,k);
                       
            n = n+1;
        end
    end
end

%define a start grid for the streamline
Xpoints = linspace(Xlims(1),Xlims(2),gridres);
Zpoints = Zcuts;
Ypoints = linspace(Ylims(1),Ylims(2),gridres);
n = 1;
for i = 1:length(Xpoints)
    for j = 1:length(Ypoints)
        for k = 1:length(Zpoints)
            Xstart(n) = Xpoints(i);
            Ystart(n) = Ypoints(j);
            Zstart(n) = Zpoints(k); 
            n=n+1;
        end
    end
end
size(Xs)
size(X)
size(U)
quiver3(Xs,Ys,Zs,U,V,W,'k')
scatter3(Xstart,Ystart,Zstart,'.r')
streamline(X,Y,Z,MomX,MomY,MomZ,Xstart,Ystart,Zstart)

% xlim(xlimits)
% ylim(ylimits)
% zlim(zlimits)
xlabel('X')
ylabel('Y')
zlabel('Z')
% view(3)

end

