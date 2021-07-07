function [R_munu] = ricciT5(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

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
            if s(j)>=3
                R_munu{i,j} = R_munu{i,j} - padDiff(diff(G{a,i,a},1,j),j);
            end
            
            for b = 1:4
                R_munu{i,j} = R_munu{i,j} + G{a,a,b}.*G{b,i,j} - G{a,j,b}.*G{b,a,i};
            end
        end
    end
end

end

