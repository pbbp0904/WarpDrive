function [shiftMatrix, points] = makeAlcubierreShiftMatrixPW(rDim,zDim,radius,goalHeight,sigma)
shiftMatrix = zeros(rDim,zDim);
points = [];

vs = goalHeight;
zs = (zDim+1)/2;
R = radius;
for i = 1:rDim
    for j = 1:zDim
        r = i-1;
        %z = j-(zDim-1)/2;
        z = j;
        shiftMatrix(i,j) = (vs*(cosh(2*R*sigma) + 1))/(cosh(2*R*sigma) + cosh(2*sigma*(r^2 + z^2 - 2*z*zs + zs^2)^(1/2)));
        if sqrt((i-1)^2+(j-((zDim+1)/2))^2) <= radius
            points = [points; [i,j]];
        end
    end
end
end
