function [G] = christoffelS(gu, gl)
%CHRISTOFFEL calculates the christoffel symbols for a 4x4 cell array metric
%tensor

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

G = cell(4,4,4);
parfor lambda = 1:4
    for mu = 1:4
        for sigma = 1:4
            G{lambda, mu, sigma} = zeros(t,x,y,z); 
            for kappa = 1:4
                if s(sigma)>=3
                    G{lambda, mu, sigma} = G{lambda, mu, sigma} + 0.5.*gu{kappa,lambda}.*padDiff(diff(gl{mu,kappa},1,sigma),sigma);
                end
                if s(mu)>=3
                    G{lambda, mu, sigma} = G{lambda, mu, sigma} + 0.5.*gu{kappa,lambda}.*padDiff(diff(gl{sigma,kappa},1,mu),mu);
                end
                if s(kappa)>=3
                    G{lambda, mu, sigma} = G{lambda, mu, sigma} - 0.5.*gu{kappa,lambda}.*padDiff(diff(gl{mu,sigma},1,kappa),kappa);
                end
            end
        end
    end
end


end

