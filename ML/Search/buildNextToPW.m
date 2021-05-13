function [nextTo] = buildNextToPW(r,z,shiftMatrix)
[h,w] = size(shiftMatrix);
nextTo = 0;
for i=-1:1
    for j =-1:1
        %if(abs(shiftMatrix(min(max(i+r,1),h),min(max(j+z,1),w)))>0)
            nextTo = 1;
            return
        %end
    end
end

end