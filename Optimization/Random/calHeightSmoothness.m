function [metricHeight, smoothness] = calHeightSmoothness(inputMetric,radius)

[~,~,r,z] = size(inputMetric);

points = [];

for i = 1:r
    for j = 1:z
        if sqrt(i^2+(j-z/2)^2) <= radius
            points = [points inputMetric(1,1,i,j)];
        end
    end
end

metricHeight = mean(points)+1;

roughness = sum(abs(points-mean(points)));
smoothness = 1/roughness;

end