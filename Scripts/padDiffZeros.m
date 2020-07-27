function [A] = padDiffZeros(A,D)
%PADDIFFZEROS Takes as input a 4-D array and dimension and pads zeros to the
%corresponding diff dimension

[t,x,y,z] = size(A);

switch D
    case 1
        A(t+1,:,:,:) = 0;
    case 2
        A(:,x+1,:,:) = 0;
    case 3
        A(:,:,y+1,:) = 0;
    case 4
        A(:,:,:,z+1) = 0;
end
end

