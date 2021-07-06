function [SM] = metricGet_Schwarszchild2(radius,maxGrid)

% dtdt        = rs/(x^2 + y^2 + z^2)^(1/2) - 1
% dxdx        = 1 - (rs*x^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dydy        = 1 - (rs*y^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dzdz        = 1 - (rs*z^2)/((rs - (x^2 + y^2 + z^2)^(1/2))*(x^2 + y^2 + z^2))
% dtdx = dxdt = 0
% dtdy = dydt = 0
% dtdz = dzdt = 0
% dxdy = dydx = (2*rs*x*y)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))
% dxdz = dzdx = (2*rs*x*z)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))
% dydz = dzdy = (2*rs*y*z)/((x^2 + y^2 + z^2)^(3/2) - rs*(x^2 + y^2 + z^2))

% maxGrid = 100;
% rs = 0.2;
rs = radius;

X = 1:maxGrid;
Y = 1:maxGrid;
Z = 1:maxGrid;



% dt cross terms
SM{1,2} = zeros(1,maxGrid,maxGrid,maxGrid);
SM{2,1} = zeros(1,maxGrid,maxGrid,maxGrid);
SM{1,3} = zeros(1,maxGrid,maxGrid,maxGrid);
SM{3,1} = zeros(1,maxGrid,maxGrid,maxGrid);
SM{1,4} = zeros(1,maxGrid,maxGrid,maxGrid);
SM{4,1} = zeros(1,maxGrid,maxGrid,maxGrid);


for i = X
    for j = Y
        for k = Z
            x = i-(maxGrid-1)/2;
            y = j-(maxGrid-1)/2;
            z = k-(maxGrid-1)/2;
            
            r = sqrt(x^2+y^2+z^2);
            theta = acos(z/r);
            phi = atan2(y,x);
            
            % Diagonal terms
            SM{1,1}(1,i,j,k) = -(1-rs/r);
            SM{2,2}(1,i,j,k) = 1/(1-rs/r)*(cos(phi)^2*sin(theta)^2) + cos(phi)^2*cos(theta)^2 + sin(phi)^2;
            SM{3,3}(1,i,j,k) = 1/(1-rs/r)*(sin(theta)^2*sin(phi)^2) + sin(phi)^2*cos(theta)^2 + cos(phi)^2;
            SM{4,4}(1,i,j,k) = 1/(1-rs/r)*(cos(theta)^2) + sin(theta)^2;
            
            % Spatial cross terms
            SM{2,3}(1,i,j,k) = 1/(1-rs/r)*(2*cos(phi)*sin(theta)^2*sin(phi)) + 2*cos(phi)*cos(theta)^2*sin(phi) - 2*sin(phi)*cos(phi);
            SM{3,2}(1,i,j,k) = SM{2,3}(1,i,j,k);
            SM{2,4}(1,i,j,k) = 1/(1-rs/r)*(2*cos(phi)*cos(theta)*sin(theta)) - 2*cos(phi)*cos(theta)*sin(theta);
            SM{4,2}(1,i,j,k) = SM{2,4}(1,i,j,k);
            SM{3,4}(1,i,j,k) = 1/(1-rs/r)*(2*sin(theta)*sin(phi)*cos(theta)) - 2*sin(phi)*cos(theta)*sin(theta);
            SM{4,3}(1,i,j,k) = SM{3,4}(1,i,j,k);
        end
    end
end
