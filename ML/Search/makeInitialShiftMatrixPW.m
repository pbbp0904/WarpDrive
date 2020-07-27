function [shiftMatrix, points] = makeInitialShiftMatrixPW(rDim,zDim,radius,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];
for i = 1:rDim
    for j = 1:zDim
        if sqrt((i-1)^2+(j-((zDim+1)/2))^2) <= radius
            shiftMatrix(i,j) = goalHeight;
            points = [points; [i,j]];
        end
    end
end
end