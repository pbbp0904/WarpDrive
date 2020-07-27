% dtdt        = (vs^2*sinh(2*R*sigma)^2)/(tanh(R*sigma)^2*(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))^2) - 1
% dpdp        = r^2
% drdr        = 1
% dzdz        = 1
% dtdp = dpdt = 0
% dtdr = drdt = 0
% dtdz = dzdt = -(2*vs*(cosh(2*R*sigma) + 1))/(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))
% dpdr = drdp = 0
% dpdz = dzdp = 0
% drdz = dzdr = 0



maxZGrid = 100;
maxRGrid = 50;

zs = 0;
vs = 1.5;
R = 30;
sigma = 4/R;

AM = {};


% Non-time diagonal terms
AM{2,2} = ones(1,1,maxRGrid,maxZGrid).*R^2;  % dpdp term
AM{3,3} = ones(1,1,maxRGrid,maxZGrid);       % drdr term
AM{4,4} = ones(1,1,maxRGrid,maxZGrid);       % dzdz term

% Non-Z time cross terms
AM{1,2} = zeros(1,1,maxRGrid,maxZGrid);      % dtdp term
AM{2,1} = zeros(1,1,maxRGrid,maxZGrid);      % dpdt term
AM{1,3} = zeros(1,1,maxRGrid,maxZGrid);      % dtdr term
AM{3,1} = zeros(1,1,maxRGrid,maxZGrid);      % drdt term


% Other cross terms
for i = 2:4
    for j = 2:4
        if i~=j
            AM{i,j} = zeros(1,1,maxRGrid,maxZGrid);
        end
    end
end

% Alcubierre Terms
for i = 1:maxRGrid
    for j = 1:maxZGrid
        
        r = i;
        %r = i-(maxGrid-1)/2;
        z = j-(maxZGrid-1)/2;
        
        

        % dt^2 term
        AM{1,1}(1,1,i,j) = (vs^2*sinh(2*R*sigma)^2)/(tanh(R*sigma)^2*(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))^2) - 1;
        %AM{1,1}(1,1,i,j) = (vs^2*sinh(2*R*sigma)^2)/(tanh(R*sigma)^2*(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))^2) + 0.01;
        
        % dzdt cross terms
        AM{1,4}(1,1,i,j) = -(2*vs*(cosh(2*R*sigma) + 1))/(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)));
        AM{4,1}(1,1,i,j) = AM{1,4}(1,1,i,j);
    end
end







