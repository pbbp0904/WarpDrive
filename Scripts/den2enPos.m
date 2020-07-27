function [totE] = den2enPos(enTen)
%DEN2EN Sums all of the positive energy density values in the energy
%desntity

enDen = gather(enTen{1,1});
[t,x,y,z] = size(enDen);

totE = 0;
for h = 1:t
    for i = 1:x
        for j = 1:y
            for k = 1:z
                e = enDen(1,i,j,k);
                if e>0
                    totE = totE + e/t/x/y/z;
                end
            end
        end
    end
end

end