function [G] = christoffelS3(gu, gl)
%CHRISTOFFEL calculates the christoffel symbols for a 4x4 cell array metric
%tensor

[t,x,y,z] = size(gu{1,1});
s = [t,x,y,z];

G = cell(4,4,4);
parfor lambda = 1:4
    for mu = 1:4
        for nu = 1:4
            G{lambda, mu, nu} = zeros(t,x,y,z); 
            for sigma = 1:4
                if s(mu)>=3
                    G{lambda, mu, nu} = G{lambda, mu, nu} + 0.5 .* padDiff(diff(gl{sigma,nu},1,mu),mu) .* gu{lambda,sigma};
                end
                if s(nu)>=3
                    G{lambda, mu, nu} = G{lambda, mu, nu} + 0.5 .* padDiff(diff(gl{sigma,mu},1,nu),nu) .* gu{lambda,sigma};
                end
                if s(sigma)>=3
                    G{lambda, mu, nu} = G{lambda, mu, nu} - 0.5 .* padDiff(diff(gl{mu,nu},1,sigma),sigma) .* gu{lambda,sigma};
                end
            end
        end
    end
end


end

