function [Q] = calcDen(inputMetric)

s = length(inputMetric);
AM={};
metricCyl_Alcubierre
RAM = {};
RAM{1,1} = cyl2rec(inputMetric,[s/2, s/2],-1);
RAM{1,2} = zeros(1,s,s,s);
RAM{2,1} = RAM{1,2};
RAM{1,3} = zeros(1,s,s,s);
RAM{3,1} = RAM{1,3};
RAM{1,4} = cyl2rec(AM{1,4},[s/2, s/2],0);
RAM{4,1} = RAM{1,4};
RAM{2,3} = zeros(1,s,s,s);
RAM{3,2} = RAM{2,3};
RAM{2,4} = zeros(1,s,s,s);
RAM{4,2} = RAM{2,4};
RAM{3,4} = zeros(1,s,s,s);
RAM{4,3} = RAM{3,4};
RAM{2,2} = ones(1,s,s,s);
RAM{3,3} = ones(1,s,s,s);
RAM{4,4} = ones(1,s,s,s);
Z = met2den(RAM);
Q = [];
Q(:,:,:) = Z{1,1}(1,:,:,:);

end