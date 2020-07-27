function [B] = padDiff(A,D)
%PADDIFFZEROS Takes as input a 4-D array and dimension and pads zeros to the
%corresponding diff dimension

[t,x,y,z] = size(A);

switch D
    case 1
        B(2:t,:,:,:) = (A(1:t-1,:,:,:)+A(2:t,:,:,:))./2;
        B(1,:,:,:) = B(2,:,:,:);
        B(t+1,:,:,:) = B(t,:,:,:);
    case 2
        B(:,2:x,:,:) = (A(:,1:x-1,:,:)+A(:,2:x,:,:))./2;
        B(:,1,:,:) = B(:,2,:,:);
        B(:,x+1,:,:) = B(:,x,:,:);
    case 3
        B(:,:,2:y,:) = (A(:,:,1:y-1,:)+A(:,:,2:y,:))./2;
        B(:,:,1,:) = B(:,:,2,:);
        B(:,:,y+1,:) = B(:,:,y,:);
    case 4
        B(:,:,:,2:z) = (A(:,:,:,1:z-1)+A(:,:,:,2:z))./2;
        B(:,:,:,1) = B(:,:,:,2);
        B(:,:,:,z+1) = B(:,:,:,z);
end
end

