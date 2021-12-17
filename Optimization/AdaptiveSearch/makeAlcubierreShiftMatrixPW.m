function [shiftMatrix, points] = makeAlcubierreShiftMatrixPW(rDim,zDim,radius,goalHeight,sigma)
shiftMatrix = zeros(rDim,zDim);
points = [];

vs = goalHeight;
zs = (zDim+1)/2;
R = radius;
for i = 1:rDim
    for j = 1:zDim
        r = i-1;
        z = j;
        rs = sqrt(r^2 + (z-zs)^2);
        shiftMatrix(i,j) = vs*(tanh(sigma*(rs+R)) - tanh(sigma*(rs-R)))/(2*tanh(sigma*R));
        if rs <= R
            points = [points; [i,j]];
        end
    end
end
end
