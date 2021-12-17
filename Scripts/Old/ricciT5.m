function [R_munu] = ricciT5(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

% Form from (https://en.wikipedia.org/wiki/Ricci_curvature) Definition via
% local coordinates on a smooth manifold section
% Form from Wikipedia, Same as T1 and T3, JUST PLAIN WRONG; DO NOT USE
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

R_munu = cell(4,4);
for j = 1:4
    for k = 1:4
        R_munu{j,k} = zeros(t,x,y,z); 
        for i = 1:4
            
            if s(i)>=3
                R_munu{j,k} = R_munu{j,k} + padDiff(diff(G{i,j,k},1,i),i);
            end
            if s(j)>=3
                R_munu{j,k} = R_munu{j,k} - padDiff(diff(G{i,k,i},1,j),j);
            end
            
            for p = 1:4
                R_munu{j,k} = R_munu{j,k} + G{i,i,p}.*G{p,j,k} - G{i,j,p}.*G{p,i,k};
            end
        end
    end
end

end

