function [R] = ricciS(R_munu,gu)
%RICCI calculates the Ricci scalar for a given Ricci tensor and metric
%tensor

R = 0;
for mu = 1:4
    for nu = 1:4
        R = R + gu{mu,nu}.*R_munu{mu,nu};
    end
end

end

