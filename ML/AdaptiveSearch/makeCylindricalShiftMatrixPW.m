function [shiftMatrix, points] = makeCylindricalShiftMatrixPW(rDim,zDim,radius,depth,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];

for i = 1:rDim
    for j = 1:zDim
        if i <= radius && j >= floor((zDim+1)/2-depth/2) && j <= ceil((zDim+1)/2+depth/2)
            shiftMatrix(i,j) = goalHeight;
            points = [points; [i,j]];
        end
        if i <= radius+10*goalHeight && i > radius && j >= floor((zDim+1)/2-depth/2) && j <= ceil((zDim+1)/2+depth/2)
            %shiftMatrix(i,j) =  1/2*(radius+2*goalHeight-i)^2/(radius+2*goalHeight-radius);
            %shiftMatrix(i,j) =  goalHeight*(radius+10*goalHeight-i)/(radius+10*goalHeight-radius);
            %shiftMatrix(i,j) =  goalHeight*(rDim-i)/(rDim-radius);
            shiftMatrix(i,j) =  -1/2*(i-radius+10*goalHeight)^2/(radius+10*goalHeight-radius)/10*goalHeight+2*goalHeight;
        end
    end
end
end