function [totE] = den2en(enDen)
%DEN2EN Converts energy density tensor into total energy tensor

[t,x,y,z] = size(enDen{1,1});


for i = 1:4
    for j = 1:4
        totE(i,j) = sum(sum(sum(sum(enDen{i,j}))))/t/x/y/z; %#ok<AGROW>
    end
end

totE = gather(totE);

end