function [R_munu] = ricciT1(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

% Form from (https://en.wikipedia.org/wiki/Ricci_curvature) Definition via
% local coordinates on a smooth manifold section
% Form from Wikipedia, Same as T3 and T5, JUST PLAIN WRONG; DO NOT USE
[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

R_munu = cell(4,4);
for mu = 1:4
    for nu = 1:4
        R_munu{mu,nu} = zeros(t,x,y,z); 
        for rho = 1:4
            
            if s(rho)>=3
                R_munu{mu,nu} = R_munu{mu,nu} + padDiff(diff(G{rho,nu,mu},1,rho),rho);
            end
            if s(mu)>=3
                R_munu{mu,nu} = R_munu{mu,nu} - padDiff(diff(G{rho,rho,nu},1,mu),mu);
            end
            
            for lambda = 1:4
                R_munu{mu,nu} = R_munu{mu,nu} + G{rho,rho,lambda}.*G{lambda,nu,mu} - G{rho,nu,lambda}.*G{lambda,rho,mu};
            end
        end
    end
end

end

