function [shiftMatrix, mask] = makeInitialShiftMatrix(rDim,zDim,radius,goalHeight)
shiftMatrix = zeros(rDim,zDim);
for i = 1:rDim
    for j = 1:zDim
        if sqrt((i-1)^2+(j-((zDim+1)/2))^2) <= radius
            shiftMatrix(i,j) = goalHeight;
        end
    end
end
mask = shiftMatrix./(-goalHeight) + 1;
end