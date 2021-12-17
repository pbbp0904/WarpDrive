function [shiftMatrix, points] = makeStreamlineShiftMatrixPW(rDim,zDim,sizeScale,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];

for i = 1:rDim
    for j = 1:zDim
        if sizeScale == 1
            if i <= 2*sizeScale && round(abs(j-(zDim+1)/2)) <= 4*sizeScale
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end

            if i <= 20*sizeScale && round(abs(j-(zDim+1)/2)) <= 2*sizeScale
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end

            if i <= 24*sizeScale && round(abs(j-(zDim+1)/2)) <= sizeScale
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
        end
        
        if sizeScale == 2
            if i <= 1 && round(abs(j-(zDim+1)/2)) <= 9
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            
            if i <= 2 && round(abs(j-(zDim+1)/2)) <= 7
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            
            if i <= 3 && round(abs(j-(zDim+1)/2)) <= 6
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            
            if i <= 5 && round(abs(j-(zDim+1)/2)) <= 5
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end

            if i <= 40 && round(abs(j-(zDim+1)/2)) <= 4
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end

            if i <= 46 && round(abs(j-(zDim+1)/2)) <= 3
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            if i <= 50 && round(abs(j-(zDim+1)/2)) <= 2
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            if i <= 53 && round(abs(j-(zDim+1)/2)) <= 1
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
            
            if i <= 56 && round(abs(j-(zDim+1)/2)) <= 0.5
                shiftMatrix(i,j) = goalHeight;
                points = [points; [i,j]];
            end
        end
    end
end
end