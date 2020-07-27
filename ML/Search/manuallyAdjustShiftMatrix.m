function [shiftMatrix] = manuallyAdjustShiftMatrix(shiftMatrix,r,z,adj)
shiftMatrix(r,z) = shiftMatrix(r,z) + adj;
drawWarpFieldPW(shiftMatrix);
end

