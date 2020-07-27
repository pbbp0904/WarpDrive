% dtdt        = -1
% dxdx        =  1
% dydy        =  1
% dzdz        =  1
% dtdx = dxdt =  0
% dtdy = dydt =  0
% dtdz = dzdt =  0
% dxdy = dydx =  0
% dxdz = dzdx =  0
% dydz = dzdy =  0


maxGrid = 100;

FM{1,1} = -ones(1,maxGrid,maxGrid,maxGrid);
FM{2,2} =  ones(1,maxGrid,maxGrid,maxGrid);
FM{3,3} =  ones(1,maxGrid,maxGrid,maxGrid);
FM{4,4} =  ones(1,maxGrid,maxGrid,maxGrid);

for i = 1:4
    for j = 1:4
        if i~=j
            FM{i,j} = zeros(1,maxGrid,maxGrid,maxGrid);
        end
    end
end