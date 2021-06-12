function [totE] = den2en(enDen)
%DEN2EN Converts energy density tensor into total energy tensor


for i = 1:4
    for j = 1:4
        totE(i,j) = sum(enDen{i,j},'all');
    end
end

totE = gather(totE);

end