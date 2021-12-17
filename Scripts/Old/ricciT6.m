function [R_munu] = ricciT6(gu,gl)
%RICCI calculates the Ricci tensor for a given metric tensor and its
%inverse

% Form from (https://en.wikipedia.org/wiki/Ricci_curvature) introduction section
% Same as T2 and T4
[t,x,y,z] = size(gl{1,1});
s = [t,x,y,z];


% Ricci tensor
R_munu = cell(4,4);


% Precalculate metric derivatives for speed
diffgl = cell(4,4,4);

for i = 1:4
    for j = 1:4
        for k = 1:4
            if s(k) >= 3
                diffgl{i,j,k} = padDiff(diff(gl{i,j},1,k),k);
            else
                diffgl{i,j,k} = zeros(t,x,y,z);
            end
        end
    end
end


% Construct Ricci tensor
for i = 0:3
    for j = 0:3

        R_munu{i+1,j+1} = zeros(t,x,y,z);
        
        for a = 0:3
            for b = 0:3

                % First term
                if s(b+1) >= 3
                    R_munu{i+1,j+1} = R_munu{i+1,j+1} + 1/2 .* gu{a+1,b+1} .* (  padDiff(diff(diffgl{i+1,j+1,a+1},1,(b+1)),(b+1)) ) ;
                end
                if s(j+1) >= 3
                    R_munu{i+1,j+1} = R_munu{i+1,j+1} + 1/2 .* gu{a+1,b+1} .* (  padDiff(diff(diffgl{a+1,b+1,i+1},1,(j+1)),(j+1)) ) ;
                end
                if s(a+1) >= 3
                    R_munu{i+1,j+1} = R_munu{i+1,j+1} + 1/2 .* gu{a+1,b+1} .* ( -padDiff(diff(diffgl{i+1,b+1,j+1},1,(a+1)),(a+1)) - padDiff(diff(diffgl{j+1,b+1,i+1},1,(a+1)),(a+1)) ) ;
                end

                for c = 0:3
                    for d = 0:3
                        % Second term
                        R_munu{i+1,j+1} = R_munu{i+1,j+1} +   1/2  .* gu{a+1,b+1} .* gu{c+1,d+1} .* ( 1/2.*diffgl{a+1,c+1,i+1}.*diffgl{b+1,d+1,j+1} + diffgl{i+1,c+1,a+1}.*diffgl{j+1,d+1,b+1} - diffgl{i+1,c+1,a+1}.*diffgl{j+1,b+1,d+1} );
                        
                        % Third term
                        R_munu{i+1,j+1} = R_munu{i+1,j+1} + (-1/4) .* gu{a+1,b+1} .* gu{c+1,d+1} .* ( diffgl{j+1,c+1,i+1} + diffgl{i+1,c+1,j+1} - diffgl{i+1,j+1,c+1} ) .* ( 2.*diffgl{b+1,d+1,a+1} - diffgl{a+1,b+1,d+1} );
                    end
                end
            end
        end
    end
end


end

