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



maxGrid = 100;

zs = 0;
vs = 1;
R = 20;
sigma = 6/R;

AM = {};


% Non-time diagonal terms
AM{2,2} = ones(1,maxGrid,maxGrid,maxGrid).*R^2;  % dpdp term
AM{3,3} = ones(1,maxGrid,maxGrid,maxGrid);       % drdr term
AM{4,4} = ones(1,maxGrid,maxGrid,maxGrid);       % dzdz term

% Non-Z time cross terms
AM{1,2} = zeros(1,maxGrid,maxGrid,maxGrid);      % dtdp term
AM{2,1} = zeros(1,maxGrid,maxGrid,maxGrid);      % dpdt term
AM{1,3} = zeros(1,maxGrid,maxGrid,maxGrid);      % dtdr term
AM{3,1} = zeros(1,maxGrid,maxGrid,maxGrid);      % drdt term


% Other cross terms
for i = 2:4
    for j = 2:4
        if i~=j
            AM{i,j} = zeros(1,maxGrid,maxGrid,maxGrid);
        end
    end
end

% Alcubierre Terms
for i = 1:maxGrid
    for j = 1:maxGrid
        for k = 1:maxGrid
            
            z = i-(maxGrid-1)/2;
            r = j+10;

            % dt^2 term
            AM{1,1}(1,k,i,j) = (vs^2*sinh(2*R*sigma)^2)/(tanh(R*sigma)^2*(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)))^2) - 1;

            % dzdt cross terms
            AM{1,4}(1,k,i,j) = -(2*vs*(cosh(2*R*sigma) + 1))/(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)));
            AM{4,1}(1,k,i,j) = AM{1,2}(1,k,i,j);
        end
    end
end







