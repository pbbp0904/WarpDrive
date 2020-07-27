function [recArray] = cyl2rec(cylArray,xyOffset,outValue,padding)
%CLY2REC Takes in a cylindrically symetric 4-D cylindrical double array and outputs a 4-D
%rectangular double array. Transfers t,p,r,z -> t,x,y,z. Input must be
%spherically symetric in p. xyOffset is a length 2 input to determine the
%offset of the radial symmetry axis in x and y. outValue is the value
%specified when the rectangular coordinate is outside the bounds of the
%cylindrical coordinate.

[t,~,r,z] = size(cylArray);

% Convert to cartesian
for i = 1:2*r
    for j = 1:2*r
        radiusValue = sqrt((i-xyOffset(1))^2+(j-xyOffset(2))^2);
        radiusSubValue = mod(radiusValue,1);
        for k = 1:z
            for h = 1:t
                if radiusValue + 1 <= r 
                    % Weighted average
                    recArray(h,i,j,k) = (1-radiusSubValue)*cylArray(h,1,floor(radiusValue+1),k)+radiusSubValue*cylArray(h,1,ceil(radiusValue+1),k);
                elseif radiusValue < r
                    % Weighted average
                    recArray(h,i,j,k) = (1-radiusSubValue)*cylArray(h,1,max(floor(radiusValue+1),1),k)+radiusSubValue*outValue;
                else
                    recArray(h,i,j,k) = outValue; 
                end
            end
        end
    end
end

% Adding padding
% Shifting array
recArray(:,padding+1:2*r+padding,padding+1:2*r+padding,padding+1:2*r+padding) = recArray(:,:,:,:);

% Pad with outValue
recArray(:,1:padding,:,:) = outValue;
recArray(:,:,1:padding,:) = outValue;
recArray(:,:,:,1:padding) = outValue;
recArray(:,2*r+padding+1:2*r+2*padding,:,:) = outValue;
recArray(:,:,2*r+padding+1:2*r+2*padding,:) = outValue;
recArray(:,:,:,2*r+padding+1:2*r+2*padding) = outValue;

end

