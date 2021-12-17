function [R_munu] = ricciT7(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols


% Form from substituting from Hartle, same as T9
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

R_munu = cell(4,4);
for mu = 1:4
    for nu = 1:4
        R_munu{mu,nu} = zeros(t,x,y,z); 
        for lambda = 1:4
            
            if s(lambda)>=3
                R_munu{mu,nu} = R_munu{mu,nu} + padDiff(diff(G{lambda,mu,nu},1,lambda),lambda);
            end
            if s(nu)>=3
                R_munu{mu,nu} = R_munu{mu,nu} - padDiff(diff(G{lambda,mu,lambda},1,nu),nu);
            end
            
            for sigma = 1:4
                R_munu{mu,nu} = R_munu{mu,nu} + G{sigma,mu,nu}.*G{lambda,sigma,lambda} - G{sigma,mu,lambda}.*G{lambda,sigma,nu};
            end
        end
    end
end




end

