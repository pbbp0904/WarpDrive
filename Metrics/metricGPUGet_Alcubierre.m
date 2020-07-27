function [AM] = metricGPUGet_Alcubierre(xs,vs,R,sigma,maxGrid)
% dtdt        = -(1-(vs^2*(tanh(sigma*(R + ((x - xs)^2 + y^2 + z^2)^(1/2))) + tanh(sigma*(R - ((x - xs)^2 + y^2 + z^2)^(1/2))))^2)/(4*tanh(R*sigma)^2))
% dxdx        =  1
% dydy        =  1
% dzdz        =  1
% dtdx = dxdt =  2*(-(vs*(tanh(sigma*(R + ((x - xs)^2 + y^2 + z^2)^(1/2))) + tanh(sigma*(R - ((x - xs)^2 + y^2 + z^2)^(1/2)))))/(2*tanh(R*sigma)))
% dtdy = dydt =  0
% dtdz = dzdt =  0
% dxdy = dydx =  0
% dxdz = dzdx =  0
% dydz = dzdy =  0



% xs = 0;
% vs = 1;
% R = 30;
% sigma = 6/R;
% sigma = sigma/R;
% maxGrid = 100;



% Non-time diagonal terms
AM{2,2} = ones(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
AM{3,3} = ones(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
AM{4,4} = ones(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');

% Non-X time cross terms
AM{1,3} = zeros(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
AM{3,1} = zeros(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
AM{1,4} = zeros(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
AM{4,1} = zeros(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');

% Other cross terms
for i = 2:4
    for j = 2:4
        if i~=j
            AM{i,j} = zeros(1,maxGrid(1),maxGrid(2),maxGrid(3),'double','gpuArray');
        end
    end
end


% Alcubierre Terms
for i = 1:maxGrid(1)
    for j = 1:maxGrid(2)
        for k = 1:maxGrid(3)
            
            x = i-(maxGrid(1)-1)/2;
            y = j-(maxGrid(2)-1)/2;
            z = k-(maxGrid(3)-1)/2;
            
            % dt^2 term
            AM{1,1}(1,i,j,k) = -(1-(vs^2*(tanh(sigma*(R + ((x - xs)^2 + y^2 + z^2)^(1/2))) + tanh(sigma*(R - ((x - xs)^2 + y^2 + z^2)^(1/2))))^2)/(4*tanh(R*sigma)^2));
            
            % dxdt cross terms
            AM{1,2}(1,i,j,k) = 2*(-(vs*(tanh(sigma*(R + ((x - xs)^2 + y^2 + z^2)^(1/2))) + tanh(sigma*(R - ((x - xs)^2 + y^2 + z^2)^(1/2)))))/(2*tanh(R*sigma)));
            AM{2,1}(1,i,j,k) = AM{1,2}(1,i,j,k);
        end
    end
end

AM{1,1} = gpuArray(AM{1,1});
AM{1,2} = gpuArray(AM{1,2});
AM{2,1} = gpuArray(AM{2,1});


end