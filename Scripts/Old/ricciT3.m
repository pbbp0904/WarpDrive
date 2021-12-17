function [R_munu] = ricciT3(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

% Form from (https://en.wikipedia.org/wiki/Ricci_curvature) Definition via
% local coordinates on a smooth manifold section
% Form from Wikipedia, Same as T1 and T5, JUST PLAIN WRONG; DO NOT USE
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

R_munu = cell(4,4);
for i = 1:4
    for j = 1:4
        R_munu{i,j} = zeros(t,x,y,z); 
        for a = 1:4
            
            if s(a)>=3
                R_munu{i,j} = R_munu{i,j} + padDiff(diff(G{a,i,j},1,a),a);
            end
            if s(i)>=3
                R_munu{i,j} = R_munu{i,j} - padDiff(diff(G{a,a,j},1,i),i);
            end
            
            for b = 1:4
                R_munu{i,j} = R_munu{i,j} + G{a,a,b}.*G{b,i,j} - G{a,i,b}.*G{b,a,j};
            end
        end
    end
end

end

