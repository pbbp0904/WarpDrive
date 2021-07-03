function [R_munu] = ricciT9(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

R_munu = cell(4,4);
for alpha = 1:4
    for beta = 1:4
        R_munu{alpha,beta} = zeros(t,x,y,z); 
        for gamma = 1:4
            
            if s(gamma)>=3
                R_munu{alpha,beta} = R_munu{alpha,beta} + padDiff(diff(G{gamma,alpha,beta},1,gamma),gamma);
            end
            if s(beta)>=3
                R_munu{alpha,beta} = R_munu{alpha,beta} - padDiff(diff(G{gamma,alpha,gamma},1,beta),beta);
            end
            
            for delta = 1:4
                R_munu{alpha,beta} = R_munu{alpha,beta} + G{gamma,alpha,beta}.*G{delta,gamma,delta} - G{gamma,alpha,delta}.*G{delta,beta,gamma};
            end
        end
    end
end




end

