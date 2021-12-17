function [shiftMatrix, points] = makeExponentialShiftMatrixPW(rDim,zDim,radius,goalHeight)
shiftMatrix = zeros(rDim,zDim);
points = [];
for i = 1:rDim
    for j = 1:zDim
        if sqrt((i-1)^2+(j-((zDim+1)/2))^2) <= radius
            shiftMatrix(i,j) = goalHeight;
            points = [points; [i,j]];
        else
            shiftMatrix(i,j) = goalHeight*abs(exp(-sqrt(2*(i-(radius+1)))))*( (abs(j-((zDim+1)/2))<=radius) + ( (abs(j-((zDim+1)/2))>radius) * exp(-(abs(j-((zDim+1)/2))-radius)) ) );
            
        end
    end
end
end

