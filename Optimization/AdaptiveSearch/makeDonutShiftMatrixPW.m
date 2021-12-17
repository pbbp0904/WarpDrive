function [shiftMatrix, points] = makeDonutShiftMatrixPW(rDim,zDim,radius,depth,offset,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];

for i = 1:rDim
    for j = 1:zDim
        if i >= offset && i <= radius+offset && j >= floor((zDim+1)/2-depth/2) && j <= ceil((zDim+1)/2+depth/2)
            shiftMatrix(i,j) = goalHeight;
            points = [points; [i,j]];
        end
    end
end
end