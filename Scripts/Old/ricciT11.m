function [R_munu] = ricciT11(G,gu)
%RICCI calculates the Ricci tensor for a given christoffel symbols

% Just plain wrong; DO NOT USE

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

Rie = cell(4,4,4,4);
for mu = 1:4
    for nu = 1:4
        for lambda = 1:4
            for sigma = 1:4
                Rie{lambda,mu,nu,sigma} = zeros(t,x,y,z);
                
                if s(nu)>=3
                    Rie{lambda,mu,nu,sigma} = Rie{lambda,mu,nu,sigma} + padDiff(diff(G{lambda,mu,sigma},1,nu),nu);
                end
                if s(sigma)>=3
                    Rie{lambda,mu,nu,sigma} = Rie{lambda,mu,nu,sigma} - padDiff(diff(G{lambda,mu,nu},1,sigma),sigma);
                end

                for eta = 1:4
                    Rie{lambda,mu,nu,sigma} = Rie{lambda,mu,nu,sigma} + G{eta,mu,sigma}.*G{lambda,eta,nu} - G{eta,mu,nu}.*G{lambda,nu,sigma};
                end
            end
        end
    end
end

R_munu = cell(4,4);
for mu = 1:4
    for nu = 1:4
        R_munu{mu,nu} = zeros(t,x,y,z); 
        for lambda = 1:4
            R_munu{mu,nu} = R_munu{mu,nu} + Rie{lambda,mu,lambda,nu};
        end
    end
end




end

