clear;
close all

Data = load('30-60-6-0.7365-MIN.mat');

Ematrix = Data.energyDensity;
Xmom = squeeze(Ematrix{1,2}.*sign(Ematrix{1,1}));
Ymom = squeeze(Ematrix{1,3}.*sign(Ematrix{1,1}));
Zmom = squeeze(Ematrix{1,4}.*sign(Ematrix{1,1}));

% Xmom = squeeze(Ematrix{1,2});
% Ymom = squeeze(Ematrix{1,3});
% Zmom = squeeze(Ematrix{1,4});


steps = 8;
timestep = 1000; 

%startgrid = [3*round(length(Xmom))/4,3*round(length(Xmom))/4,round(length(Xmom)/2)];
startgrid = [round(length(Xmom))/2,round(length(Xmom))/2,round(length(Xmom)/2)];

Pos = zeros(steps,3);
Pos(1,:) = startgrid;
startV = [1,0,0]*0;
MOMscalar = 1;
xParticleNumber = 15;
yParticleNumber = 15;
zParticleNumber = 15;

figure(4)
Xgrid = linspace(1,length(Xmom),length(Xmom));
Ygrid = linspace(1,length(Xmom),length(Xmom));
Zgrid = linspace(1,length(Xmom),length(Xmom));
[Xgrid_matrix, Ygrid_matrix, Zgrid_matrix] = meshgrid(Xgrid,Ygrid,Zgrid);
%quiver3(Xgrid_matrix,Ygrid_matrix,Zgrid_matrix,Xmom,Ymom,Zmom)
view(90,0)

for m = 1:xParticleNumber
    for j = 1:yParticleNumber
        for k = 1:zParticleNumber
            startgrid = [length(Xmom)/xParticleNumber*m,length(Xmom)/yParticleNumber*j,length(Xmom)/zParticleNumber*k/3 + length(Xmom)*(1/2-1/6)];
            Pos = zeros(steps,3);
            Pos(1,:) = startgrid;
            for i = 1:steps-1
                 x = floor(Pos(i,1));
                 y = floor(Pos(i,2));
                 z = floor(Pos(i,3));

                 if (x == 0 || x == length(Xmom)) || (y == 0 || y == length(Xmom)) || (z == 0 || z == length(Xmom)) 
                     break;
                 end

                 xSub = Pos(i,1)-x;
                 ySub = Pos(i,2)-y;
                 zSub = Pos(i,3)-z;

                 xMomentum = (Xmom(x,y,z)*(1-xSub)+Xmom(x+1,y,z)*(xSub) + Xmom(x,y,z)*(1-ySub)+Xmom(x,y+1,z)*(ySub) + Xmom(x,y,z)*(1-zSub)+Xmom(x,y,z+1)*(zSub))/3;
                 yMomentum = (Ymom(x,y,z)*(1-xSub)+Ymom(x+1,y,z)*(xSub) + Ymom(x,y,z)*(1-ySub)+Ymom(x,y+1,z)*(ySub) + Ymom(x,y,z)*(1-zSub)+Ymom(x,y,z+1)*(zSub))/3;
                 zMomentum = (Zmom(x,y,z)*(1-xSub)+Zmom(x+1,y,z)*(xSub) + Zmom(x,y,z)*(1-ySub)+Zmom(x,y+1,z)*(ySub) + Zmom(x,y,z)*(1-zSub)+Zmom(x,y,z+1)*(zSub))/3;

                 momvec(i,:) = [xMomentum, yMomentum, zMomentum]*MOMscalar;
                 momvec2(i,:) = [Xmom(x,y,z),Ymom(x,y,z), Zmom(x,y,z)];
                 Pos(i+1,1) = Pos(i,1)+(xMomentum)*timestep;
                 Pos(i+1,2) = Pos(i,2)+(yMomentum)*timestep;
                 Pos(i+1,3) = Pos(i,3)+(zMomentum)*timestep;
            %      drawnow
                 if mod(i,10) == 501
                    figure(1)
                    plot3(Pos(2:i,1),Pos(2:i,2),Pos(2:i,3))       
                 end
                 if mod(i,500) == 501
                    figure(1)
                    title(['step ' num2str(i)])
                    plot3(Pos(2:i,1),Pos(2:i,2),Pos(2:i,3))   
                    figure(2)
                    subplot(1,3,1)
                    plot(2:i,momvec(2:i,1))
                    subplot(1,3,2)
                    plot(2:i,momvec(2:i,2))
                    subplot(1,3,3)
                    plot(2:i,momvec(2:i,3))  
                 end
                 if mod(i,500) == 501  
                    figure(3)
                    subplot(1,3,1)
                    plot(2:i,momvec2(2:i,1))
                    subplot(1,3,2)
                    plot(2:i,momvec2(2:i,2))
                    subplot(1,3,3)
                    plot(2:i,momvec2(2:i,3))  
                end
            end

            figure(4)
            hold on
            %plot3(Pos(2:i-1,1),Pos(2:i-1,2),Pos(2:i-1,3),'Color',[0 0 tanh((sum((Pos(1:end-1,1)-Pos(2:end,1)).^2)+sum((Pos(1:end-1,2)-Pos(2:end,2)).^2)+sum((Pos(1:end-1,3)-Pos(2:end,3)).^2))/(length(Xmom)/steps))])
            quiver3(Pos(2,1),Pos(2,2),Pos(2,3),Pos(5,1)-Pos(2,1),Pos(5,2)-Pos(2,2),0,'off','Color',[0 0 tanh((sum((Pos(1:end-1,1)-Pos(2:end,1)).^2)+sum((Pos(1:end-1,2)-Pos(2:end,2)).^2)+sum((Pos(1:end-1,3)-Pos(2:end,3)).^2))/(length(Xmom)/steps))])
            drawnow
        end
    end
end


%   
% figure(1)
%         hold on
%         
%         Xgrid = linspace(0,length(Xmom),length(Xmom));
%         Ygrid = linspace(0,length(Xmom),length(Xmom));
%         Zgrid = linspace(0,length(Xmom),length(Xmom));
%         xslice = [1,length(Xmom)/2];
%         yslice = [];
%         zslice = length(Xmom)/2;
%         surf(Xgrid,Ygrid,abs(squeeze(Ematrix{1,1}(1,:,:,zslice))))
%         alpha color
%         shading flat