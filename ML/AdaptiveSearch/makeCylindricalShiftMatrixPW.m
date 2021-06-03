function [shiftMatrix, points] = makeCylindricalShiftMatrixPW(rDim,zDim,radius,depth,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];

for i = 1:rDim
    for j = 1:zDim
        if i <= radius && j >= floor((zDim+1)/2-depth/2) && j <= ceil((zDim+1)/2+depth/2)
            shiftMatrix(i,j) = goalHeight;
            points = [points; [i,j]];
        end
    end
end
end