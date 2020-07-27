function [metricHeight, smoothness] = calcHeightSmoothPW(inputShiftMatrix,radius,goalHeight)
    inputMetric = inputShiftMatrix;
    [r,z] = size(inputMetric);

    points = [];

    for i = 1:r
        for j = 1:z
            if sqrt(i^2+(j-z/2)^2) <= radius
                points = [points inputMetric(i,j)];
            end
        end
    end

    metricHeight = mean(points);

    roughness = sum(abs(points-goalHeight));
    smoothness = 1/roughness;
end
